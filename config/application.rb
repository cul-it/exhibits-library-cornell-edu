require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Exhibits
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # I18n support for Indonesian
    config.i18n.available_locales = Spotlight::Engine.config.i18n_locales.keys + [:id]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = { id: :en }

    config.to_prepare do
      # for each prepended class
      # OriginalApp::OriginalClassName.prepend PrependedModuleName::OriginalClassName
      # Controllers
      Spotlight::CatalogController.prepend PrependedControllers::CatalogController
      Spotlight::ConfirmationsController.prepend PrependedControllers::ConfirmationsController
      Spotlight::ExhibitsController.prepend PrependedControllers::ExhibitsController
      Spotlight::Resources::UploadController.prepend PrependedControllers::UploadController
      Spotlight::Resources::CsvUploadController.prepend PrependedControllers::CsvUploadController

      # Models
      Spotlight::FeaturedImage.prepend PrependedModels::FeaturedImage
      Spotlight::Resources::Upload.prepend PrependedModels::Upload

      # Services
      Spotlight::ExhibitImportExportService.prepend PrependedServices::ExhibitImportExportService

      # Uploaders
      Spotlight::FeaturedImageUploader.prepend PrependedUploaders::FeaturedImageUploader
    end
  end
end
