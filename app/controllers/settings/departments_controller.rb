module Settings
	class DepartmentsController < ApplicationController
		respond_to :html, :json

		def new
			@department = Department.new
			respond_modal_with @department
		end

		def create
			@department = Department.create(schedule_params)
			respond_modal_with @department, location: settings_path
		end

		def edit
			@department = Department.find(params[:id])
			respond_modal_with @department
		end

		def update
			@department = Department.find(params[:id])
			@department.update(schedule_update_params)
			respond_modal_with @department, location: request.referrer
		end

		private
		def schedule_params
			params.require(:department).permit(:name, :code)
		end
	end
end