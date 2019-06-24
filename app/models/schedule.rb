class Schedule < ApplicationRecord
	enum shift_type:[:day_shift, :night_shift]

  has_many :employees
  validates :starts_at, :ends_at, :shift_type, presence: true
  before_save :set_name

  def am_starts
    starts_at
  end

  def pm_ends
    ends_at
  end

  def total_minutes
  	((ends_at - starts_at) / 1.minutes).abs.ceil
  end

  def total_working_hours
  	(total_minutes.to_f / 60).to_s.split(".").first.to_i
  end

	def total_working_minutes
		(total_minutes - (total_working_hours*60))
	end

  private
  def time_parse(time)
    Time.new(2000, 1, 1, time.hour, time.min, 0, Time.zone)
  end

  def set_name
  	self.name = "#{shift_type.titleize} (#{starts_at.strftime('%I:%M %p')} - #{ends_at.strftime('%I:%M %p')})"
  end
end
