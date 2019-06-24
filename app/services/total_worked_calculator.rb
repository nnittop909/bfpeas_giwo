class TotalWorkedCalculator
	
	def initialize(date, employee)
		@date = date
		@employee = employee
		@total_minutes = @employee.business_hour.total_minutes
	end

	def calculate_total
		total = 0
    Time.days_in_month(@date.month, @date.year).times.each do |day|
      parsed_date = Date.new(@date.year, @date.month, (day + 1))
      daily_time_records = @employee.daily_time_records(parsed_date)
      if daily_time_records.present?
	      worked_time = RegularWorkCalculator.new(parsed_date, @employee).worked_total
	      total += worked_time
	    end
    end
    total
	end

	def days
		(calculate_total / @total_minutes)
	end

	def hours
		mins = calculate_total - (days.to_i*@total_minutes)
		(mins / 60)
	end

	def minutes
		mins = calculate_total - (days.to_i*@total_minutes) - (hours.to_i*60)
	end

	def get_days
		days.to_i
	end

	def get_hours
		hours.to_i
	end

	def get_minutes
		minutes.to_i
	end

	def worked_in_words
    day_unit          = get_days == 1 ? "day" : "days"
    hour_unit         = get_hours == 1 ? "hour" : "hours"
    min_unit          = get_minutes == 1 ? "min." : "mins."
    days_with_unit    = get_days.zero? ? nil : "#{get_days} #{day_unit}"
    hours_with_unit   = get_hours.zero? ? nil : "#{get_hours} #{hour_unit}"
    minutes_with_unit = get_minutes.zero? ? nil : "#{get_minutes} #{min_unit}"
    [days_with_unit, hours_with_unit, minutes_with_unit].compact.join(", ")
	end
end