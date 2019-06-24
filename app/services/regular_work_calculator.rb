class RegularWorkCalculator

	def initialize(date, employee)
		@date = date.to_date
		@employee = employee
    # @am_starts_at = DateTimeParser.new(@date, @employee.business_hour.am_starts).parse!
    # @am_ends_at   = DateTimeParser.new(@date, @employee.business_hour.am_ends).parse! if !@employee.security_personel?
    # @pm_starts_at = DateTimeParser.new(@date, @employee.business_hour.pm_starts).parse! if !@employee.security_personel?
	end

	# def am_worked_total
 #    if @employee.dtr_am_in(@date).present? && @employee.dtr_am_out(@date).present?
	# 		am_in = @employee.dtr_am_in(@date).logged_at <= @am_starts_at ? @am_starts_at : @employee.dtr_am_in(@date).logged_at
	# 		am_out = @employee.dtr_am_out(@date).logged_at >= @am_ends_at ? @am_ends_at : @employee.dtr_am_out(@date).logged_at
 #    	if @employee.dtr_am_in(@date).logged_at <= @am_ends_at
	#     	((am_out - am_in) / 1.minutes).abs.ceil
	# 		else
	# 			0
	# 		end
 #    else
 #      0
 #    end
 #  end

 #  def pm_worked_total
 #    if @employee.dtr_pm_in(@date).present? && @employee.dtr_pm_out(@date).present?
 #    	pm_in = @employee.dtr_pm_in(@date).logged_at <= @pm_starts_at ? @pm_starts_at : @employee.dtr_pm_in(@date).logged_at
	# 		pm_out = @employee.dtr_pm_out(@date).logged_at >= pm_ends_at ? pm_ends_at : @employee.dtr_pm_out(@date).logged_at
 #    	if @employee.dtr_pm_in(@date).logged_at <= pm_ends_at
	#     	((pm_out - pm_in) / 1.minutes).abs.ceil
	#     else
	#     	0
	#     end
 #    else
 #      0
 #    end
	# end

	def worked_total
		# if @employee.security_personel?
		# 	if @employee.dtr_am_in(@date).present? && @employee.dtr_pm_out(@date).present?
		# 		time_in = @employee.dtr_am_in(@date).logged_at <= @am_starts_at ? @am_starts_at : @employee.dtr_am_in(@date).logged_at
		# 		time_out = @employee.dtr_pm_out(@date).logged_at >= pm_ends_at ? pm_ends_at : @employee.dtr_pm_out(@date).logged_at
	 #    	if @employee.dtr_am_in(@date).logged_at <= pm_ends_at
		#     	((time_in - time_out) / 1.minutes).abs.ceil
		# 		else
		# 			0
		# 		end
		# 	else
		# 		0
		# 	end
		# else
		# 	am_worked_total + pm_worked_total
		# end
		@employee.worked_times.where(date: @date).sum(:duration)
	end

	def get_hours
		(worked_total / 60).to_i
	end

	def get_minutes
		worked_total - (get_hours * 60)
	end

	# def pm_ends_at
	# 	if @employee.security_personel?
	# 		total_hours = @employee.business_hour.total_working_hours
	# 		total_minutes = @employee.business_hour.total_working_minutes
 #    	@am_starts_at + total_hours.hours + total_minutes.minutes
 #    else
 #    	DateTimeParser.new(@date, @employee.business_hour.pm_ends).parse!
 #    end
	# end
end