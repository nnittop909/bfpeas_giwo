module Reports
	class AttendancesController < ApplicationController

		def index
			@date = params[:date].present? ? Date.parse(params[:date]) : Date.today
			@employees = Employee.not_admin.all
			respond_to do |format|
        format.html
        format.pdf do
          pdf = AttendanceSheetPdf.new(employees: @employees, date: @date)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "#{@title}.pdf"
        end
      end
		end
	end
end