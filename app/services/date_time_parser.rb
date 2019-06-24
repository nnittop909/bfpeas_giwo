class DateTimeParser
	attr_accessor :date, :time

	def initialize(date, time)
		@date = date
		@time = time
	end

	def parse!
		Time.new(date.year, date.month, date.day, time.hour, time.min, 0, Time.zone)
	end
end