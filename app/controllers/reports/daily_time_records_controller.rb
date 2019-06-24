module Reports
	class DailyTimeRecordsController < ApplicationController

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
	end
end