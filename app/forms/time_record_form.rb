class TimeRecordForm
	include ActiveModel::Model
	attr_accessor :employee_id, :logged_at, :date, :log_type, :meridian
	validates :logged_at, :date, presence: true
	validate :invalid_time

	def create!
		ActiveRecord::Base.transaction do
			create_time_record
		end
	end

	def create_time_record
		if log_type == "in"
			destroy_all_recent_logins
			find_employee.time_logs.logged_in.create(logged_at: parsed_time)
			recreate_worked_times
		elsif log_type == "out"
			destroy_all_worked_times_and_recent_logouts
			find_employee.time_logs.logged_out.create(logged_at: parsed_time)
			create_worked_times
		end
	end

	def recreate_worked_times
		if meridian == "AM" && find_employee.recent_am_logouts(parsed_time).present?
			find_employee.worked_times.where(out_at: am_starts_at..pm_starts_at).destroy_all
			find_employee.worked_times.create(
				date: parsed_time.to_date, 
				in_at: parsed_time,
				out_at: recent_am_logout_at,
				overtime: 0,
				duration: recompute_duration
			)
		elsif meridian == "PM" && find_employee.recent_pm_logouts(parsed_time).present?
			find_employee.worked_times.where(out_at: pm_starts_at..parsed_time.end_of_day).destroy_all
			find_employee.worked_times.create(
				date: parsed_time.to_date, 
				in_at: parsed_time,
				out_at: recent_pm_logout_at,
				overtime: recompute_overtime,
				duration: recompute_duration
			)
		end
	end

	def destroy_all_recent_logins
		find_employee.recent_am_logins(parsed_time).destroy_all if meridian == "AM"
		find_employee.recent_pm_logins(parsed_time).destroy_all if meridian == "PM"
	end

	def destroy_all_worked_times_and_recent_logouts
		if parsed_time.between?(am_starts_at, pm_starts_at)
			find_employee.recent_am_logouts(parsed_time).destroy_all 
			find_employee.worked_times.where(out_at: am_starts_at..pm_starts_at).destroy_all
		end
		if parsed_time.between?(pm_starts_at, parsed_time.end_of_day)
			find_employee.recent_pm_logouts(parsed_time).destroy_all
			find_employee.worked_times.where(out_at: pm_starts_at..parsed_time.end_of_day).destroy_all 
		end
	end

	def create_worked_times
		unless recent_login_at.between?(am_ends_at, pm_starts_at) && parsed_time.between?(am_ends_at, pm_starts_at)
			find_employee.worked_times.create(
				date: parsed_time.to_date, 
				in_at: recent_login_at,
				out_at: parsed_time,
				overtime: compute_overtime,
				duration: compute_duration
			)
		end
	end

	def compute_duration
		if recent_login_at.between?(parsed_time.beginning_of_day, am_ends_at) #recent login is AM?
			login_at = recent_login_at < am_starts_at ? am_starts_at : recent_login_at
			if parsed_time > am_ends_at
				((am_ends_at - login_at) / 1.minutes).abs.ceil
			else
				((parsed_time - login_at) / 1.minutes).abs.ceil
			end
		elsif recent_login_at.between?(am_ends_at, parsed_time.end_of_day) #recent login is PM?
			login_at = recent_login_at < pm_starts_at ? pm_starts_at : recent_login_at
			if parsed_time > pm_ends_at
				((pm_ends_at - login_at) / 1.minutes).abs.ceil
			else
				if parsed_time > pm_starts_at
					((parsed_time - login_at) / 1.minutes).abs.ceil
				else
					0
				end
			end
		end
	end

	def recompute_duration
		if parsed_time.between?(parsed_time.beginning_of_day, am_ends_at) #recent login is AM?
			login_at = parsed_time < am_starts_at ? am_starts_at : parsed_time
			if recent_am_logout_at > am_ends_at
				((am_ends_at - login_at) / 1.minutes).abs.ceil
			else
				((recent_am_logout_at - login_at) / 1.minutes).abs.ceil
			end
		elsif parsed_time.between?(am_ends_at, parsed_time.end_of_day) #recent login is PM?
			login_at = parsed_time < pm_starts_at ? pm_starts_at : parsed_time
			if recent_pm_logout_at > pm_ends_at
				((pm_ends_at - login_at) / 1.minutes).abs.ceil
			else
				if recent_pm_logout_at > pm_starts_at
					((recent_pm_logout_at - login_at) / 1.minutes).abs.ceil
				else
					0
				end
			end
		end
	end

	def invalid_time
		if log_type == "in" && meridian == "AM" #AM Login
			errors[:logged_at] << "#{to_time_format} is an invalid time for AM Login." if parsed_time.strftime('%p') == "PM"
		elsif log_type == "in" && meridian == "PM" #PM Login
			errors[:logged_at] << "#{to_time_format} is an invalid time for PM Login." unless parsed_time.between?(am_ends_at, pm_ends_at)
		elsif log_type == "out" && meridian == "AM" #AM Logout
			errors[:logged_at] << "#{to_time_format} is an invalid time for AM Logout." unless parsed_time.between?(am_starts_at, pm_starts_at)
		elsif log_type == "out" && meridian == "PM" #PM Logout
			errors[:logged_at] << "#{to_time_format} is an invalid time for PM Logout." unless parsed_time.between?(pm_starts_at, parsed_time.end_of_day)
		end
	end

	def compute_overtime
		parsed_time > pm_ends_at ? ((parsed_time - pm_ends_at) / 1.minutes).abs.ceil : 0
	end

	def recompute_overtime
		recent_pm_logout_at > pm_ends_at ? ((recent_pm_logout_at - pm_ends_at) / 1.minutes).abs.ceil : 0
	end

	def find_employee
		Employee.find(employee_id)
	end

	def parsed_time
		DateTimeParser.new(Date.parse(date), Time.parse(logged_at)).parse!
	end

	def to_time_format
		parsed_time.strftime('%I:%M %p')
	end

	def am_starts_at
    find_employee.business_am_starts_at(parsed_time)
  end

  def am_ends_at
    find_employee.business_am_ends_at(parsed_time)
  end

  def pm_starts_at
    find_employee.business_pm_starts_at(parsed_time)
  end

  def pm_ends_at
    find_employee.business_pm_ends_at(parsed_time)
  end

  def recent_login_at
  	find_employee.recent_login(parsed_time).logged_at if find_employee.recent_login(parsed_time).present?
  end

  def recent_am_logout_at
  	find_employee.recent_am_logouts(parsed_time).last.logged_at if find_employee.recent_am_logouts(parsed_time).present?
  end

  def recent_pm_logout_at
  	find_employee.recent_pm_logouts(parsed_time).last.logged_at if find_employee.recent_pm_logouts(parsed_time).present?
  end
end