module Employees
	class EmergencyContactsController < ApplicationController
		respond_to :html, :json

		def new
			@employee = current_school.employees.find(params[:employee_id])
			@emergency_contact = EmergencyContactProcessor.new
			respond_modal_with @emergency_contact
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
			@emergency_contact = EmergencyContactProcessor.new(emergency_contact_params).process!
			respond_modal_with @emergency_contact, location: request.referer
		end

		def edit
			@employee = current_school.employees.find(params[:employee_id])
			@emergency_contact = EmergencyContactProcessor.new("id" => @employee.id)
			respond_modal_with @emergency_contact
		end

		def update
			@employee = current_school.employees.find(params[:employee_id])
			@emergency_contact = EmergencyContactProcessor.new(emergency_contact_params.merge("id" => @employee.id)).update!
			respond_modal_with @emergency_contact, location: request.referer
		end

		private
		def emergency_contact_params
			params.require(:emergency_contact_processor).permit(
				:employee_id,
				:first_name,
				:middle_name,
				:last_name,
				:relationship,
				:mobile_number,
				:sitio,
				:barangay,
				:municipality,
				:province
			)
		end
	end
end