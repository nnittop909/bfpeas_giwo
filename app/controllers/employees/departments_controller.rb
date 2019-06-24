module Employees
	class DepartmentsController < ApplicationController
		respond_to :html, :json

		def edit
			@employee = Employee.find(params[:employee_id])
			respond_modal_with @employee
		end

		def update
			@employee = Employee.find(params[:employee_id])
			@employee.update(department_params)
			respond_modal_with @employee, 
				location: employee_settings_url(@employee)
		end

		private
    def department_params
      params.require(:employee).permit(:department_id)
    end
  end
end