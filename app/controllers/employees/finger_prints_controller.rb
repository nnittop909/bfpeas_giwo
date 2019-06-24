module Employees
	class FingerPrintsController < ApplicationController

		def index
			@employee = current_school.employees.find(params[:employee_id])
		end

		def new
			@employee = current_school.employees.find(params[:employee_id])
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
		end

		private
		def finger_print_params
		end
	end
end