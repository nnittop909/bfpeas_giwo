module Reports
	class EmployeeInformationsController < ApplicationController

		def index
			@employee = Employee.find(params[:employee_id])
			@title = "Employee Information"
			respond_to do |format|
        format.html
        format.pdf do
          pdf = EmployeeInformationPdf.new(employee: @employee)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "#{@title}.pdf"
        end
      end
		end
	end
end