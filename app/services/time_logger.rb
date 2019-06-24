class TimeLogger
	include ActiveModel::Model
	attr_reader :employee, :time, :am_starts_at, :am_ends_at, :pm_starts_at, :pm_ends_at, :logged_in_at

	def initialize(args={})
		@employee = args[:employee]
		@time = args[:time].present? ? args[:time] : Time.now
		@am_starts_at   = DateTimeParser.new(@time, @employee.business_hour.am_starts).parse!
		@am_ends_at     = DateTimeParser.new(@time, @employee.business_hour.am_ends).parse!
  	@pm_starts_at   = DateTimeParser.new(@time, @employee.business_hour.pm_starts).parse!
  	@pm_ends_at     = DateTimeParser.new(@time, @employee.business_hour.pm_ends).parse!
  	@logged_in_at   = @employee.recent_login(@time).logged_at if @employee.recent_login(@time).present?
	end

	def log!
		ActiveRecord::Base.transaction do
			if employee.logged_in?(time)
				logout = employee.time_logs.logged_out.create(logged_at: time)
				create_worked_times(logout) unless logged_in_at.between?(am_ends_at, pm_starts_at) && logout.logged_at.between?(am_ends_at, pm_starts_at)
			else
				employee.time_logs.logged_in.create(logged_at: time)
			end
		end
	end

	def create_worked_times(logout)
		employee.worked_times.create(
			date: time.to_date, 
			in_at: logged_in_at,
			out_at: logout.logged_at,
			overtime: compute_overtime(logout.logged_at),
			duration: compute_duration(logout.logged_at)
		)
	end

	def compute_duration(logged_out_at)
		if logged_in_at.between?(time.beginning_of_day, am_ends_at) #recent login is AM?
			login_at = logged_in_at < am_starts_at ? am_starts_at : logged_in_at
			if logged_out_at > am_ends_at
				((am_ends_at - login_at) / 1.minutes).abs.ceil
			else
				((logged_out_at - login_at) / 1.minutes).abs.ceil
			end
		elsif logged_in_at.between?(am_ends_at, time.end_of_day) #recent login is PM?
			login_at = logged_in_at < pm_starts_at ? pm_starts_at : logged_in_at
			if logged_out_at > pm_ends_at
				((pm_ends_at - login_at) / 1.minutes).abs.ceil
			else
				if logged_out_at > pm_starts_at
					((logged_out_at - login_at) / 1.minutes).abs.ceil
				else
					0
				end
			end
		end
	end

	def compute_overtime(logged_out_at)
		logged_out_at > pm_ends_at ? ((logged_out_at - pm_ends_at) / 1.minutes).abs.ceil : 0
	end
end