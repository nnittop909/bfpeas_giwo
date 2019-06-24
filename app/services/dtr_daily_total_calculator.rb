class DtrDailyTotalCalculator
	
	def initialize(date, employee)
		@date = date.to_date
		@employee = employee
		@from_date = @date.beginning_of_day
    @to_date   = @date.end_of_day
    @am_starts_at = DateTimeParser.new(@date, @employee.business_hour.am_starts).parse!
    @am_ends_at   = DateTimeParser.new(@date, @employee.business_hour.am_ends).parse!
    @pm_starts_at = DateTimeParser.new(@date, @employee.business_hour.pm_starts).parse!
    @pm_ends_at   = DateTimeParser.new(@date, @employee.business_hour.pm_ends).parse!
    @am_total = ((@am_ends_at - @am_starts_at) / 1.minutes).abs.to_i
    @pm_total = ((@pm_ends_at - @pm_starts_at) / 1.minutes).abs.to_i
	end

	def total_worked
		@employee.worked_times.where(date: @date).sum(:duration)
	end

	def get_worked_hours
		(total_worked.to_f / 60).to_s.split(".").first.to_i
	end

	def get_worked_minutes
		total_worked - (get_worked_hours * 60)
	end
#################################################################################
	def total_overtime
		@employee.worked_times.where(date: @date).sum(:overtime)
	end

	def get_overtime_hours
		(total_overtime.to_f / 60).to_s.split(".").first.to_i
	end

	def get_overtime_minutes
		(total_overtime - (get_overtime_hours*60)).to_i
	end
##################################################################################

  def total_undertime #minutes
    if !total_worked.zero? && total_worked < (@am_total + @pm_total)
      (@am_total + @pm_total) - total_worked
    else
      0
    end
  end

	def get_undertime_hours
    (total_undertime.to_f / 60).to_s.split(".").first.to_i
	end

	def get_undertime_minutes
		(total_undertime - (get_undertime_hours*60)).to_i
	end

end