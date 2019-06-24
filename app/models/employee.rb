class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum   role:[:faculty_member, :staff, :security_personel, :admin]
  enum   marital_status:[:single, :married, :widowed, :anulled]
  enum   schedule:[:first_shift, :second_shift]
  BLACKLISTED_ROLES = ['security_personel', 'admin']

  # pg_search_scope :search, :against => [:full_name, :first_name, :middle_name, :last_name]

  belongs_to :school
  belongs_to :department
  belongs_to :schedule

  has_one_attached :avatar
  has_one    :license_and_insurance, dependent: :destroy
  has_one    :emergency_contact, dependent: :destroy
  has_many   :addresses, as: :addressable, dependent: :destroy
  has_many   :contacts, as: :contactable, dependent: :destroy
  has_many   :position_titles, dependent: :destroy
  has_many   :id_cards, dependent: :destroy
  has_many   :time_records, dependent: :destroy
  has_many   :time_logs, dependent: :destroy
  has_many   :worked_times, dependent: :destroy

  validates :first_name, :last_name, :role, presence: true

  before_validation :set_email_password, on: :create
  before_save :set_full_name
  after_save :set_default_image, on: :create

  def self.whitelisted_roles
    roles.keys - BLACKLISTED_ROLES
  end

  def current_card
    id_cards.where(default: true).last
  end

  def current_address
    addresses.where(default: true).last
  end

  def current_contact
    contacts.where(default: true).last
  end

  def current_title
    position_titles.where(default: true).first
  end

  def recent_log(time)
    time_logs.where(logged_at: time.beginning_of_day..time.end_of_day).order(created_at: :desc).first
  end

  def recent_login(time)
    time_logs.logged_in.where(logged_at: time.beginning_of_day..time.end_of_day).order(created_at: :desc).first
  end

  def recent_logout(time)
    time_logs.logged_out.where(logged_at: time.beginning_of_day..time.end_of_day).order(created_at: :desc).first
  end

  def logged_in?(time)
    recent_log(time).present? ? recent_log(time).logged_in? : false
  end

  def log_status(time)
    if time_logs.where(logged_at: time.beginning_of_day..time.end_of_day).present?
      recent_log(time).status
    else
      "logged_out"
    end
  end

  def logged_in_for_am?(time)
    recent_am_logins(time).present?
  end

  def recent_am_logins(time)
    am_ends_at = DateTimeParser.new(time, business_hour.am_ends).parse!
    time_logs.logged_in.where(logged_at: time.beginning_of_day..am_ends_at).order(:logged_at)
  end

  def recent_am_logouts(time)
    am_starts_at = DateTimeParser.new(time, business_hour.am_starts).parse!
    pm_starts_at = DateTimeParser.new(time, business_hour.pm_starts).parse!
    time_logs.logged_out.where(logged_at: am_starts_at..pm_starts_at).order(:logged_at)
  end

  def logged_in_for_pm?(time)
    recent_pm_logins(time).present?
  end

  def recent_pm_logins(time)
    am_ends_at = DateTimeParser.new(time, business_hour.am_ends).parse!
    time_logs.logged_in.where(logged_at: am_ends_at..time.end_of_day).order(:logged_at)
  end

  def recent_pm_logouts(time)
    pm_starts_at = DateTimeParser.new(time, business_hour.pm_starts).parse!
    time_logs.logged_out.where(logged_at: pm_starts_at..time.end_of_day).order(:logged_at)
  end

  def recent_logged_at(time)
    if time_logs.where(logged_at: time.beginning_of_day..time.end_of_day).present?
      recent_log(time).logged_at
    else
      Time.now - 1.day
    end
  end

  def log_count(date)
    time_logs.where(logged_at: date.beginning_of_day..date.end_of_day).count
  end

  def late?(date)
    am_starts_at = DateTimeParser.new(date, business_hour.am_starts).parse!
    daily_time_records(date).present? ? (dtr_am_in(date).logged_at > am_starts_at) : false
  end

  def overtime?(date)
    pm_ends_at = DateTimeParser.new(date, business_hour.pm_ends).parse!
    daily_time_records(date).present? ? (dtr_pm_out(date).logged_at > pm_ends_at + 1.hour) : false
  end

  def self.overtime(date)
    all.order(:full_name).select{ |e| e.overtime?(date) }
  end

  def self.late(date)
    all.order(:full_name).select{ |e| e.late?(date) }
  end

  def self.absent(date)
    all.order(:full_name).select{ |e| e.absent?(date) }
  end

  def self.not_admin
    where.not(role: "admin")
  end

  def absent?(date)
    am_absent?(date) && pm_absent?(date)
  end

  def am_absent?(date)
    dtr_am_in(date).blank? && dtr_am_out(date).blank?
  end

  def pm_absent?(date)
    dtr_pm_in(date).blank? && dtr_pm_out(date).blank?
  end

  def can_log_out? # can logout after 3 minutes
    ((Time.now - recent_logged_at) / 1.minutes) >= 2
    # recent_logged_at >= 2.minutes
  end

  def cannot_log_out?
    !(Time.now - (recent_logged_at + 3.seconds)).negative?
  end

  def minutes_to_log_out(time)
    duration = 2 - ((time - recent_logged_at) / 1.minutes).to_i
    unit = duration < 2 ? "minute" : "minutes"
    "#{duration} #{unit}"
  end

  def daily_time_records(date)
    from_date = date.beginning_of_day
    to_date   = date.end_of_day
    time_logs.where(logged_at: from_date..to_date).order(:logged_at)
  end

  def dtr_am_in(date)
    time_from = date.beginning_of_day
    time_to   = business_am_ends_at(date)
    daily_time_records(date).logged_in.where(logged_at: time_from..time_to).order(:logged_at).first
  end

  def dtr_am_out(date)
    time_from = business_am_starts_at(date)
    time_to   = business_pm_starts_at(date)
    daily_time_records(date).logged_out.where(logged_at: time_from..time_to).order(:logged_at).last
  end

  def dtr_pm_in(date)
    time_from = business_am_ends_at(date)
    time_to   = business_pm_ends_at(date)
    daily_time_records(date).logged_in.where(logged_at: time_from..time_to).order(:logged_at).first
  end

  def dtr_pm_out(date)
    time_from = business_pm_starts_at(date)
    time_to   = date.end_of_day
    daily_time_records(date).logged_out.where(logged_at: time_from..time_to).order(:logged_at).last
  end

  def business_hour
    if faculty_member?
      BusinessHour.faculty_member.last
    elsif staff?
      BusinessHour.staff.last
    elsif security_personel?
      schedule.present? ? schedule : Schedule.order(:name).first
    end
  end

  def business_am_starts_at(time)
    DateTimeParser.new(time, business_hour.am_starts).parse!
  end

  def business_am_ends_at(time)
    DateTimeParser.new(time, business_hour.am_ends).parse!
  end

  def business_pm_starts_at(time)
    DateTimeParser.new(time, business_hour.pm_starts).parse!
  end

  def business_pm_ends_at(time)
    DateTimeParser.new(time, business_hour.pm_ends).parse!
  end

  def overtime_config
    if faculty_member?
      OvertimeConfig.faculty_member.present? ? OvertimeConfig.faculty_member.last : OvertimeConfig.all_employees.last
    elsif staff?
      OvertimeConfig.staff.present? ? OvertimeConfig.staff.last : OvertimeConfig.all_employees.last
    elsif security_personel?
      OvertimeConfig.security_personel.present? ? OvertimeConfig.security_personel.last : OvertimeConfig.all_employees.last
    end
  end

  def dtr_daily_total(date)
    DtrDailyTotalCalculator.new(date, self)
  end

  def dtr_monthly_total(date)
    DtrMonthlyTotalCalculator.new(date, self)
  end

  def id_number
    current_card.id_number
  end

  def rfid_uid
    current_card.rfid_uid
  end

  def age
    if birthdate.present?
      ((Time.zone.now - birthdate.to_time) / 1.year.seconds).floor
    else
      "N/A"
    end
  end

  def prc_license_number
    if license_and_insurance.present?
      license_and_insurance.try(:prc_license_number) || "N/A"
    else
      "N/A"
    end
  end

  def pagibig_number
    if license_and_insurance.present?
      license_and_insurance.try(:pagibig_number) || "N/A"
    else
      "N/A"
    end
  end

  def sss_number
    if license_and_insurance.present?
      license_and_insurance.try(:sss_number) || "N/A"
    else
      "N/A"
    end
  end

  def phil_health_number
    if license_and_insurance.present?
      license_and_insurance.try(:phil_health_number) || "N/A"
    else
      "N/A"
    end
  end

  def self.for_department(args={})
    where(department_id: args[:department_id])
  end

  def self.search(keywords)
    where("full_name ilike ?", "%#{keywords}%")
  end

  def name
    full_name
  end

  def short_name
    "#{first_name.split(" ").first.titleize} #{last_name.first.titleize}."
  end

  def reversed_short_name
    if middle_name.present?
      "#{last_name}, #{first_name.split(" ").map{|a| a.first.titleize}.join("")}#{middle_name.first.titleize}"
    else
      "#{last_name}, #{first_name.split(" ").map{|a| a.first.titleize}.join("")}"
    end
  end

  def reversed_name
    if middle_name.present?
      "#{last_name.titleize}, #{first_name.titleize} #{middle_name.first.upcase}."
    else
      "#{last_name.titleize}, #{first_name.titleize}"
    end
  end

  def reversed_fullname
    if middle_name.present?
      "#{last_name.titleize}, #{first_name.titleize} #{middle_name.titleize}"
    else
      "#{last_name.titleize}, #{first_name.titleize}"
    end
  end

  def fullname_and_title
    if current_title.present?
      if current_title.beginning_of_name?
        "#{current_title} #{full_name}"
      else
        "#{full_name}, #{current_title}"
      end
    else
      "#{full_name}"
    end
  end

  private

  def set_full_name
    self.full_name =  middle_name.present? ? "#{first_name.titleize} #{middle_name.first.upcase}. #{last_name.titleize}" : "#{first_name.titleize} #{last_name.titleize}"
  end

  def set_email_password
    generated_password = Devise.friendly_token.first(8).downcase
    if email.blank? and password.blank?
      self.email = "#{first_name.gsub(" ","").downcase}_#{last_name.gsub(" ","").downcase}@ia.ph"
      self.default_key = "#{generated_password}"
      self.password = "#{generated_password}"
      self.password_confirmation = "#{generated_password}"
    elsif email.present? and password.blank?
      self.password = "#{generated_password}"
      self.password_confirmation = "#{generated_password}"
    end
  end

  def set_default_image
    if !avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.png')), filename: 'default-image.png', content_type: 'image/png')
    end
  end
end
