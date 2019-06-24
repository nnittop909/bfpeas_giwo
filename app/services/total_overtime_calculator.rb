class TotalOvertimeCalculator
	
	def initialize(date, employee)
		@date = date
		@employee = employee
	end

	def calculate_total
		total = 0
    Time.days_in_month(@date.month, @date.year).times.each do |day|
      parsed_date = Date.new(@date.year, @date.month, (day + 1))
      daily_time_records = @employee.daily_time_records(parsed_date)
      if daily_time_records.present?
	      over_time = OvertimeCalculator.new(parsed_date, @employee).total_over_time
	      total += over_time
	    end
    end
    total
	end

	def get_hours
		(calculate_total.to_f / 60).to_s.split(".").first.to_i
	end

	def get_minutes
		(calculate_total - (get_hours*60)).to_i
	end
end