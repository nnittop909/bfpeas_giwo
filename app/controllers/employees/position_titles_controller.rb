module Employees
	class PositionTitlesController < ApplicationController
		respond_to :html, :json

		def new
			@employee = current_school.employees.find(params[:employee_id])
			@position_title = @employee.position_titles.build
			respond_modal_with @position_title
		end

		def create
			@employee = current_school.employees.find(params[:employee_id])
			@employee.position_titles.destroy_all
			@position_title = @employee.position_titles.create(title_params)
			respond_modal_with @position_title, location: request.referer
		end

		private
		def title_params
			params.require(:position_title).permit(:name, :placement, :default)
		end
	end
end