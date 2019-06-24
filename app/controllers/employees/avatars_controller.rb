module Employees
	class AvatarsController < ApplicationController
		respond_to :html, :json

		def update
			@employee = current_school.employees.find(params[:employee_id])
			@employee.update(avatar_params)
			respond_modal_with @employee, location: request.referer
		end

		private
		def avatar_params
			params.require(:employee).permit(:avatar)
		end
	end
end