require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Exhibits
  class Application < Rails::Application
    # TODO: Match defaults to rails version 7.0 after confirming that app runs in prod
    # https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-6-1-to-rails-7-0
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.to_prepare do
      # for each prepended class
      # OriginalApp::OriginalClassName.prepend PrependedModuleName::OriginalClassName
      # Controllers
      Spotlight::ExhibitsController.prepend PrependedControllers::ExhibitsController
      Spotlight::Resources::UploadController.prepend PrependedControllers::UploadController
      Spotlight::CatalogController.prepend PrependedControllers::CatalogController

      # Models
      Spotlight::FeaturedImage.prepend PrependedModels::FeaturedImage
      Spotlight::Resources::Upload.prepend PrependedModels::Upload

      # Services
      Spotlight::ExhibitImportExportService.prepend PrependedServices::ExhibitImportExportService
    end
  end
end
