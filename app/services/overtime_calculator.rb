class OvertimeCalculator

	def initialize(date, employee)
		@date = date.to_date
		@employee = employee
		@from_date = @date.beginning_of_day
    @to_date   = @date.end_of_day
	end

	def total_over_time
		@employee.worked_times.where(date: @date).sum(:overtime)
	end

	def get_hours
		(total_over_time / 60).to_i
	end

	def get_minutes
		(total_over_time - (get_hours*60))
	end

	def pm_ends_at
		if @employee.security_personel?
			total_hours = @employee.business_hour.total_working_hours
			total_minutes = @employee.business_hour.total_working_minutes
    	DateTimeParser.new(@date, @employee.business_hour.am_starts).parse! + total_hours.hours + total_minutes.minutes
    else
    	DateTimeParser.new(@date, @employee.business_hour.pm_ends).parse!
    end
	end
end