module Settings
	class SignatoriesController < ApplicationController
		respond_to :html, :json

		def edit
			@config = Settings::Configuration.find(params[:id])
			respond_modal_with @config
		end

		def update
			@config = Settings::Configuration.find(params[:id])
			@config.update(signatory_params)
			respond_modal_with @config, location: request.referrer
		end

		private
		def signatory_params
			params.require(:settings_configuration).permit(:dtr_signatory)
		end
	end
end