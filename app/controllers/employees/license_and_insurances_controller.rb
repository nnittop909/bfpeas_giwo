module Employees
	class LicenseAndInsurancesController < ApplicationController
		respond_to :html, :json

		def new
			@employee = current_school.employees.find(params[:employee_id])
			@license_and_insurance = @employee.build_license_and_insurance
			respond_modal_with @license_and_insurance
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
			@license_and_insurance = @employee.create_license_and_insurance(license_and_insurance_params)
			respond_modal_with @license_and_insurance, location: request.referer
		end

		def edit
			@employee = current_school.employees.find(params[:employee_id])
			@license_and_insurance = @employee.license_and_insurance
			respond_modal_with @license_and_insurance
		end

		def update
			@employee = current_school.employees.find(params[:employee_id])
			@license_and_insurance = @employee.license_and_insurance.update(license_and_insurance_params)
			respond_modal_with @license_and_insurance, location: request.referer
		end

		private
		def license_and_insurance_params
			params.require(:license_and_insurance).permit(:prc_license_number, :pagibig_number, :sss_number, :phil_health_number, :tin_number)
		end
	end
end