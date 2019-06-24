module Settings
	class HolidaysController < ApplicationController
		respond_to :html, :json

		def new
			@holiday = Holiday.new
			respond_modal_with @holiday
		end

		def create
			@holiday = Holiday.create(holiday_params)
			respond_modal_with @holiday, location: settings_path
		end

		def edit
			@holiday = Holiday.find(params[:id])
			respond_modal_with @holiday
		end

		def update
			@holiday = Holiday.find(params[:id])
			@holiday.update(holiday_params)
			respond_modal_with @holiday, location: settings_path
		end

		private
		def holiday_params
			params.require(:holiday).permit(:holiday_type, :name, :dated_at)
		end
	end
end