module TimeRecorders
	class NonSecurityPersonel
		attr_accessor :employee, :time, :am_starts_at, :am_ends_at, :pm_starts_at, :pm_ends_at

		def initialize(args={})
			@employee = args[:employee]
			@time     = args[:time]
			@am_starts_at   = DateTimeParser.new(@time, @employee.business_hour.am_starts).parse!
			@am_ends_at     = DateTimeParser.new(@time, @employee.business_hour.am_ends).parse!
    	@pm_starts_at   = DateTimeParser.new(@time, @employee.business_hour.pm_starts).parse!
    	@pm_ends_at     = DateTimeParser.new(@time, @employee.business_hour.pm_ends).parse!
		end

		def login
			if time.between?(time.beginning_of_day, am_ends_at) #12AM to 12PM
				employee.time_records.logged_in.am.create(logged_at: time) unless employee.logged_in_for_am?(time)
			else
				employee.time_records.logged_in.pm.create(logged_at: time) unless employee.logged_in_for_pm?(time)
			end
		end

		def logout
			if time.between?(am_starts_at, pm_starts_at)
				employee.time_records.logged_out.am.create(logged_at: time) if employee.logged_in_for_am?(time)
			else
				employee.time_records.logged_out.pm.create(logged_at: time) if employee.logged_in_for_pm?(time)
			end #if employee.can_log_out? # add 1 minute interval 
		end
	end
end