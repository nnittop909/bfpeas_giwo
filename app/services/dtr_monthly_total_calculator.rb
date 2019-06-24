class DtrMonthlyTotalCalculator
	
	def initialize(date, employee)
		@date = date.to_date
		@employee = employee
		@total_worked = @employee.worked_times.where(date: @date.beginning_of_month..@date.end_of_day).sum(:duration)
		@total_overtime = @employee.worked_times.where(date: @date.beginning_of_month..@date.end_of_day).sum(:overtime)
	end

	def calculate_total
		total_undertime = 0
    Time.days_in_month(@date.month, @date.year).times.each do |day|
      parsed_date = Date.new(@date.year, @date.month, (day + 1))
      daily_time_records = @employee.daily_time_records(parsed_date)
      if daily_time_records.present?
	      under_time = UndertimeCalculator.new(parsed_date, @employee).total_under_time
	      total_undertime += under_time
	    end
    end
    { total_undertime => "total_undertime" }
	end

	def total_finder(str)
		calculate_total.key(str)
	end
###################################################################################################################
	def get_worked_days
		((@total_worked.to_f / 60) / 24).to_s.split(".").first.to_i
	end
	def get_worked_hours
		if get_worked_days.zero?
			(@total_worked.to_f / 60).to_s.split(".").first.to_i
		else
			((@total_worked.to_f - (get_worked_days*24*60)) / 60).to_s.split(".").first.to_i
		end
	end
	def get_worked_minutes
		(@total_worked.to_f - ((get_worked_days*24*60) + (get_worked_hours*60))).to_i
	end
	def worked_in_words
    day_unit          = get_worked_days == 1 ? "day" : "days"
    hour_unit         = get_worked_hours == 1 ? "hour" : "hours"
    min_unit          = get_worked_minutes == 1 ? "min." : "mins."
    days_with_unit    = get_worked_days.zero? ? nil : "#{get_worked_days} #{day_unit}"
    hours_with_unit   = get_worked_hours.zero? ? nil : "#{get_worked_hours} #{hour_unit}"
    minutes_with_unit = get_worked_minutes.zero? ? nil : "#{get_worked_minutes} #{min_unit}"
    [days_with_unit, hours_with_unit, minutes_with_unit].compact.join(", ")
	end
###################################################################################################################
	def get_undertime_hours
		(total_finder("total_undertime").to_f / 60).to_s.split(".").first.to_i
	end
	def get_undertime_minutes
		(total_finder("total_undertime").to_f - (get_undertime_hours*60)).to_i
	end
	def undertime_in_words
    hour_unit         = get_undertime_hours == 1    ? "hour" : "hours"
    min_unit          = get_undertime_minutes == 1  ? "min." : "mins."
    hours_with_unit   = get_undertime_hours.zero?   ? nil    : "#{get_undertime_hours} #{hour_unit}"
    minutes_with_unit = get_undertime_minutes.zero? ? nil    : "#{get_undertime_minutes} #{min_unit}"
    [hours_with_unit, minutes_with_unit].compact.join(", ")
	end
###################################################################################################################
	def get_overtime_hours
		(@total_overtime.to_f / 60).to_s.split(".").first.to_i
	end
	def get_overtime_minutes
		(@total_overtime.to_f - (get_overtime_hours*60)).to_i
	end
	def overtime_in_words
    hour_unit         = get_overtime_hours == 1 ? "hour" : "hours"
    min_unit          = get_overtime_minutes == 1 ? "min." : "mins."
    hours_with_unit   = get_overtime_hours.zero? ? nil : "#{get_overtime_hours} #{hour_unit}"
    minutes_with_unit = get_overtime_minutes.zero? ? nil : "#{get_overtime_minutes} #{min_unit}"
    [hours_with_unit, minutes_with_unit].compact.join(", ")
	end
end