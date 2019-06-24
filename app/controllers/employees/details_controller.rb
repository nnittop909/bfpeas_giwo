module Employees
	class DetailsController < ApplicationController
		respond_to :html, :json

		def edit
			@employee = current_employee
			respond_modal_with @employee
		end

		def update
			@employee = current_employee
			@employee.update(employee_params)
			respond_modal_with @employee, location: request.referer
		end

		private
		def employee_params
			employee.require(:employee).permit(
				:first_name,
				:middle_name,
				:last_name,
				:designation,
				:department_and_college_id
			)
		end
	end
end