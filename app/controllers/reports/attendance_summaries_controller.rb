module Reports
	class AttendanceSummariesController < ApplicationController

		def index
			@date = params[:date].present? ? Date.parse(params[:date]) : Date.today
			@employees = Employee.not_admin.all
			respond_to do |format|
        format.html
        format.pdf do
          pdf = AttendanceSummaryPdf.new(employees: @employees, date: @date)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "AttendanceSummary.pdf"
        end
      end
		end
	end
end