module Employees
	class AccountSettingsController < ApplicationController
		respond_to :html, :json

		def index
			@employee = current_employee
		end

		def edit
			@employee = current_employee
			respond_modal_with @employee
		end

		def update
			@employee = current_employee
			@employee.update(password_params)
			respond_modal_with @employee, 
				location: employee_account_settings_url(@employee)
		end

		private
    def password_params
      params.require(:employee).permit(:email, :password, :password_confirmation)
    end
  end
end