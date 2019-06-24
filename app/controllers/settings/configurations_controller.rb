module Settings
	class ConfigurationsController < ApplicationController
		respond_to :html, :json

		def edit
			@config = Settings::Configuration.find(params[:id])
			respond_modal_with @config
		end

		def update
			@config = Settings::Configuration.find(params[:id])
			@config.update(config_params)
			respond_modal_with @config, location: request.referrer
		end

		private
		def config_params
			params.require(:settings_configuration).permit(:display_duration)
		end
	end
end