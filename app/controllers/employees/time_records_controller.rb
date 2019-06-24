module Employees
	class TimeRecordsController < ApplicationController
		respond_to :html, :json

		def index
			@date = params[:date].present? ? Date.parse(params[:date]) : Date.today
			@employee = Employee.find(params[:employee_id])
			@time_records = @employee.time_records.where(logged_at: @date.beginning_of_month..@date.end_of_month)
			@signatory = Settings::Configuration.last.dtr_signatory
			@file_name = @date.strftime("%B, %Y")
			respond_to do |format|
        format.html
        format.pdf do
          pdf = DailyTimeRecordPdf.new(employee: @employee, date: @date, signatory: @signatory)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "DTR(#{@file_name}).pdf"
        end
      end
		end

		def new
			@employee = Employee.find(params[:employee_id])
			@date = Date.parse(params[:date])
			@time_record_form = TimeRecordForm.new
			respond_modal_with @time_record_form
		end

		def create
			@employee = Employee.find(params[:employee_id])
			@date = Date.parse(params[:date])
			@time_record_form = TimeRecordForm.new(time_record_params).create!
			respond_modal_with @time_record_form, 
			location: employee_time_records_url(
				employee_id: @employee.id, 
				date: @date
			)
		end

		private
		def time_record_params
			params.require(:time_record_form).permit(:employee_id, :date, :logged_at, :log_type, :meridian)
		end
	end
end