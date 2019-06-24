module Employees
	class ContactsController < ApplicationController
		respond_to :html, :json

		def new
			@employee = current_school.employees.find(params[:employee_id])
			@contact = @employee.contacts.build
			respond_modal_with @contact
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
			@contact = @employee.contacts.create(contact_params)
			respond_modal_with @contact, location: request.referer
		end

		private
		def contact_params
			params.require(:contact).permit(:number, :default)
		end
	end
end