class TotalUndertimeCalculator

	def initialize(date, employee)
		@date = date
		@employee = employee
		@days_in_month = Time.days_in_month(@date.month, @date.year)
		@sundays_and_holidays = HolidaysPlucker.new(@date).pluck! + SundaysPlucker.new(@date).pluck!
	end

	def calculate_total
		total = 0
    @days_in_month.times.each do |day|
      parsed_date = Date.new(@date.year, @date.month, (day + 1))
      daily_time_records = @employee.daily_time_records(parsed_date)
      if daily_time_records.present? && !@sundays_and_holidays.include?(parsed_date)
	      under_time = UndertimeCalculator.new(parsed_date, @employee).total_under_time
	      total += under_time
	    end
    end
    total
	end

	def get_days
		((calculate_total.to_f / 60) / 24).to_s.split(".").first.to_i
	end

	def get_hours
		if get_days.zero?
			(calculate_total.to_f / 60).to_s.split(".").first.to_i
		else
			((calculate_total.to_f - (get_days*24*60)) / 60).to_s.split(".").first.to_i
		end
	end

	def get_minutes
		(calculate_total - (get_hours*60)).to_i
	end
end