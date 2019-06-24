class RegularDays #Only requires to pass date

	def initialize(date)
		@date = date
		@beginning_of_month = @date.beginning_of_month
		@end_of_month = @date.end_of_month
	end

	def count!
		Time.days_in_month(@date.month, @date.year) -
		Holiday.where(dated_at: @beginning_of_month..@end_of_month).count -
		(@beginning_of_month..@end_of_month).group_by(&:wday)[0].count
	end

	def get_dates
		month_days = Time.days_in_month(@date.month, @date.year).times.map{|d| d+1}
		holiday_days = Holiday.where(dated_at: @beginning_of_month..@end_of_month).map{|h| h.dated_at.day}
		sunday_days = (@beginning_of_month..@end_of_month).group_by(&:wday)[0].map{|s| s.day}
		regular_days = month_days - holiday_days - sunday_days
		dates_array = []
		regular_days.each do |day|
			dates_array << Date.new(@date.year, @date.month, day)
		end
		dates_array
	end
end
