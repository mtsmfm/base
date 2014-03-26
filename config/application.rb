require File.expand_path('../boot', __FILE__)

# Don't require 'rails/all' because we use RSpec instead of rails/test_unit.
# See http://stackoverflow.com/questions/20872895.
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Base
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    config.sass.preferred_syntax = :sass

    config.generators do |g|
      g.template_engine :slim
    end

    I18n.enforce_available_locales = true

    config.action_dispatch.rescue_responses.merge! 'CanCan::AccessDenied' => :forbidden
  end
end

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  # TODO: Use other mail account!
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'localhost',
  user_name:            'inquisiv.test@sientia.ch',
  password:             '1nfo@inquisiv',
  authentication:       'plain',
  enable_starttls_auto: true
}
