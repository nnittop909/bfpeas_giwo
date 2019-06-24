module Settings
	class BusinessHoursController < ApplicationController
		respond_to :html, :json

		def new
			@business_hours = BusinessHour.new
			respond_modal_with @business_hours
		end

		def create
			@business_hours = BusinessHour.create(business_hours_params)
			respond_modal_with @business_hours, location: settings_path
		end

		def edit
			@business_hours = BusinessHour.find(params[:id])
			respond_modal_with @business_hours
		end

		def update
			@business_hours = BusinessHour.find(params[:id])
			@business_hours.update(business_hours_update_params)
			respond_modal_with @business_hours, location: settings_path
		end

		private
		def business_hours_params
			params.require(:business_hour).permit(
				:employee_role, :am_starts_at, :am_ends_at, :pm_starts_at, :pm_ends_at
			)
		end
		def business_hours_update_params
			params.require(:business_hour).permit(
				:am_starts_at, :am_ends_at, :pm_starts_at, :pm_ends_at
			)
		end
	end
end