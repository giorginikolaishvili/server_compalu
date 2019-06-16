require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CyberCompalu
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.active_record.belongs_to_required_by_default = false


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.fallbacks = [I18n.default_locale]

    #config.time_zone = 'Tbilisi'
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }
    config.action_dispatch.default_headers.merge!({
                                                      'Access-Control-Allow-Origin' => '*',
                                                      'Access-Control-Request-Method' => '*'
                                                  })
   # config.middleware.insert_before Warden::Manager, Rack::Cors


    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.autoload_paths += Dir[File.join(Rails.root, 'lib', 'helpers', '*.rb')].each {|l| require l }
    config.autoload_paths << Rails.root.join('lib')
    # config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.assets false
      g.helper false
      g.template_engine false
    end

  end
end
