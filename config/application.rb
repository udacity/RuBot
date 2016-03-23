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
      Thread.new do
        # rubot = Slack::RealTime::Client.new(websocket_ping: 40)
        # # Override the CA_FILE and CA_PATH in the embedded web client if they are set in the environment
        # if ENV['CA_FILE'] and ENV['CA_PATH']    
        #     web_client = Slack::Web::Client.new(ca_file: ENV['CA_FILE'], ca_path: ENV['CA_PATH'])
        #     rubot.web_client = web_client
        #     Rails.application.config.rubot = rubot
        # end
        @client = Client.new
        Rails.application.config.rubot = @client.setup_client
        @client.bot_behavior(Rails.application.config.rubot)
      end
    end
    
  end
end




