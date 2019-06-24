class HolidaysPlucker
	def initialize(date)
		@date = date
		@beginning_of_month = @date.beginning_of_month
		@end_of_month = @date.end_of_month
	end

	def pluck!
		Holiday.where(dated_at: @beginning_of_month..@end_of_month).map{|h| h.dated_at}
	end

	def count!
		pluck!.count
	end
end