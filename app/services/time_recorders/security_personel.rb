module TimeRecorders
	class SecurityPersonel
		attr_accessor :employee, :time, :last_login

		def initialize(args={})
			@employee = args[:employee]
			@time     = args[:time]
			@last_login = @employee.last_login
		end

		def login
			current_logins.destroy_all if current_logins.present?
			if time_is_am?
				employee.time_records.logged_in.am.create(logged_at: time)
			else
				employee.time_records.logged_in.pm.create(logged_at: time)
			end
		end

		def logout
			current_log_outs.destroy_all if current_log_outs.present?
			if time_is_am?
				employee.time_records.logged_out.am.create(logged_at: time)
			else
				employee.time_records.logged_out.pm.create(logged_at: time)
			end #if employee.can_log_out? #add 2 min interval
		end

		def total_hours
			employee.business_hour.total_working_hours
		end

		def total_minutes
			employee.business_hour.total_working_minutes
		end

		def am_starts_at #start of working time
			DateTimeParser.new(last_login, employee.business_hour.am_starts).parse!
		end

		def pm_ends_at #end of working time
			am_starts_at + total_hours.hours + total_minutes.minutes
		end

		def current_log_outs
			employee.time_records.logged_out.where(logged_at: last_login..(pm_ends_at + total_hours.hours + total_minutes.minutes)).order(:logged_at)
		end

		def current_logins
			if current_log_outs.present?
				employee.time_records.logged_in.where(logged_at: current_log_outs.first.logged_at..time)
			end
		end

		def time_is_am?
			time.strftime("%p") == "AM"
		end
	end
end