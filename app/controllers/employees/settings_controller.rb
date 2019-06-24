module Employees
	class SettingsController < ApplicationController

		def index
			@employee = Employee.find(params[:employee_id])
		end
	end
end