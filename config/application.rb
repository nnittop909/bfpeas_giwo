require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RfidDtr
  class Application < Rails::Application
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
    config.time_zone = 'Asia/Manila'
    config.active_record.default_timezone = :utc
    config.beginning_of_week = :sunday
    config.i18n.fallbacks = [I18n.default_locale]
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
  end
end
