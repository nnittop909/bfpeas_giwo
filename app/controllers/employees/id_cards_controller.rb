module Employees
	class IdCardsController < ApplicationController
		respond_to :html, :json

		def new
			@employee = current_school.employees.find(params[:employee_id])
			@id_card = @employee.id_cards.build
			respond_modal_with @id_card
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
			@id_card = @employee.id_cards.create(id_card_params)
			respond_modal_with @id_card, location: request.referer
		end

		private
		def id_card_params
			params.require(:id_card).permit(:id_number, :rfid_uid, :default)
		end
	end
end