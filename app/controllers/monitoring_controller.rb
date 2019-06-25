class MonitoringController < ApplicationController
	layout 'monitoring'
	skip_before_action :authenticate_employee!, only: [:index]

	def index
		@config = Settings::Configuration.first
		if params[:rfid_uid].present?
			@rfid_uid = IdCard.default.find_by(rfid_uid: params[:rfid_uid])
			@employee = @rfid_uid.present? ? @rfid_uid.employee : nil
			# TimeRecorder.new(employee: @employee).record! if @employee.present?
			TimeLogger.new(employee: @employee).log! if @employee.present? && @employee.can_pm_login?(Time.now)
		end
	end
end