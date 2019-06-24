module Employees
	class SchedulesController < ApplicationController
		respond_to :html, :json

		def edit
			@employee = current_school.employees.find(params[:employee_id])
			respond_modal_with @employee
		end

		def update
			@employee = current_school.employees.find(params[:employee_id])
			@employee.update(schedule_params)
			respond_modal_with @employee, location: request.referer
		end

		private
		def schedule_params
			params.require(:employee).permit(:schedule_id)
		end
	end
end