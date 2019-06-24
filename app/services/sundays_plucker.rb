class SundaysPlucker
	def initialize(date)
		@date = date
		@beginning_of_month = @date.beginning_of_month
		@end_of_month = @date.end_of_month
	end

	def pluck!
		(@beginning_of_month..@end_of_month).group_by(&:wday)[0]
	end

	def count!
		pluck!.count
	end
end