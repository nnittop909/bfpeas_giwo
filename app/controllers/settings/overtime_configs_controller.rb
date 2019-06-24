module Settings
	class OvertimeConfigsController < ApplicationController
		respond_to :html, :json

		def new
			@overtime_config = OvertimeConfig.new
			respond_modal_with @overtime_config
		end

		def create
			@overtime_config = OvertimeConfig.create(config_params)
			respond_modal_with @overtime_config, location: settings_path
		end

		def edit
			@overtime_config = OvertimeConfig.find(params[:id])
			respond_modal_with @overtime_config
		end

		def update
			@overtime_config = OvertimeConfig.find(params[:id])
			@overtime_config.update(config_params)
			respond_modal_with @overtime_config, location: request.referrer
		end

		private
		def config_params
			params.require(:overtime_config).permit(:minimum_overtime, :starts_at, :ends_at, :applies_to)
		end
	end
end