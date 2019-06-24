module Employees
	class AddressesController < ApplicationController
		respond_to :html, :json

		def new
			@employee = current_school.employees.find(params[:employee_id])
			@address = @employee.addresses.build
			respond_modal_with @address
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
			@address = @employee.addresses.create(address_params)
			respond_modal_with @address, location: request.referer
		end

		private
		def address_params
			params.require(:address).permit(:sitio, :barangay, :municipality, :province, :default)
		end
	end
end