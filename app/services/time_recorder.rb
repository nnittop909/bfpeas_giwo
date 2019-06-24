class TimeRecorder
	attr_reader :employee, :time

	def initialize(args={})
		@employee = args[:employee]
		@time = args[:time].present? ? args[:time] : Time.now
	end

	def record!
		employee.security_personel? ? for_security_personel : for_non_security_personel
	end

	def for_security_personel
		# when login is present, clear all logouts and register a new one
		if employee.time_records.present? && employee.logged_in?
			TimeRecorders::SecurityPersonel.new(employee: employee, time: time).logout
		else
			TimeRecorders::SecurityPersonel.new(employee: employee, time: time).login
		end
	end

	def for_non_security_personel
		TimeRecorders::NonSecurityPersonel.new(employee: employee, time: time).logout
		TimeRecorders::NonSecurityPersonel.new(employee: employee, time: time).login
	end

	
end