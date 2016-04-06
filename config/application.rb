require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rubot
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.after_initialize do
      puts "ENV = development? #{Rails.env.development?}"
      
      Rails.application.config.client_name = "Rubot"
      Rails.application.config.ndkey = "nd010"
      Rails.application.config.standard_response = 
        "I'm sorry, I didn't understand that. For a list of commands, type `help`."

      Thread.new do
        # @client = Client.new
        # Rails.application.config.client = @client.setup_client
        # @client.bot_behavior(Rails.application.config.client)
        # puts "CLIENT DOWN"
      end

    end
    
  end
end




