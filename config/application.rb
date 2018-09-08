# Calendar
require File.expand_path('../boot', __FILE__)

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)

# Calendar
Bundler.require(:default, Rails.env)

module K12Project
  class Application < Rails::Application
    # Calendar
    config.autoload_paths += %W(#{config.root}/lib)

    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
