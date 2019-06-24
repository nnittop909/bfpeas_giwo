class SettingsController < ApplicationController

	def index
		@config = Settings::Configuration.last
		@business_hours = BusinessHour.all
		@holidays = Holiday.all
		@overtime_configs = OvertimeConfig.all
		@schedules = Schedule.all
		@departments = Department.all
	end
end