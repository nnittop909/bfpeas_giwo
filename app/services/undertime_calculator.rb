class UndertimeCalculator

	def initialize(date, employee)
		@date = date.to_date
		@employee = employee
    @am_starts_at = @employee.business_hour.am_starts
    @am_ends_at   = @employee.business_hour.am_ends if !@employee.security_personel?
    @pm_starts_at = @employee.business_hour.pm_starts if !@employee.security_personel?
    @pm_ends_at   = @employee.business_hour.pm_ends
    @am_total = ((@am_ends_at - @am_starts_at) / 1.minutes).abs.to_i if !@employee.security_personel?
    @pm_total = ((@pm_ends_at - @pm_starts_at) / 1.minutes).abs.to_i if !@employee.security_personel?
	end

  def worked_total
    RegularWorkCalculator.new(@date, @employee).worked_total
  end

  def total_work_hours
    if @employee.security_personel?
      ((@pm_ends_at - @am_starts_at) / 1.minutes).abs.to_i
    else
      @am_total + @pm_total #minutes
    end
  end

  def total_under_time #minutes
    if !worked_total.zero? && worked_total < total_work_hours
      total_work_hours - worked_total
    else
      0
    end
  end

	def get_hours
    (total_under_time.to_f / 60).to_s.split(".").first.to_i
	end

	def get_minutes
		(total_under_time - (get_hours*60)).to_i
	end
end