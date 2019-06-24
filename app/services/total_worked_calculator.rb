class TotalWorkedCalculator
	
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
	      worked_time = RegularWorkCalculator.new(parsed_date, @employee).worked_total
	      total += worked_time
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
		if get_hours.zero?
			(calculate_total.to_f / 60).to_s.split(".").first.to_i
		else
			(calculate_total.to_f - ((get_days*24*60) + (get_hours*60))).to_i
		end
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