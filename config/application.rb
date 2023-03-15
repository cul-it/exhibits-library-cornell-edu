require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Exhibits
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_paths << Rails.root.join("lib")

    config.to_prepare do
      # for each prepended class
      # OriginalApp::OriginalClassName.prepend PrependedModuleName::OriginalClassName
      Spotlight::ExhibitsController.prepend PrependedControllers::ExhibitsController
    end
  end
end
