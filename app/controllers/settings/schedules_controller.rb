module Settings
	class SchedulesController < ApplicationController
		respond_to :html, :json

		def new
			@schedule = Schedule.new
			respond_modal_with @schedule
		end

		def create
			@schedule = Schedule.create(schedule_params)
			respond_modal_with @schedule, location: settings_path
		end

		def edit
			@schedule = Schedule.find(params[:id])
			respond_modal_with @schedule
		end

		def update
			@schedule = Schedule.find(params[:id])
			@schedule.update(schedule_update_params)
			respond_modal_with @schedule, location: request.referrer
		end

		private
		def schedule_params
			params.require(:schedule).permit(:starts_at, :ends_at, :shift_type)
		end

		def schedule_update_params
			params.require(:schedule).permit(:starts_at, :ends_at)
		end
	end
end