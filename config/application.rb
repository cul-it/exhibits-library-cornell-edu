require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Exhibits
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.autoload_paths << Rails.root.join("lib")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.to_prepare do
      # for each prepended class
      # OriginalApp::OriginalClassName.prepend PrependedModuleName::OriginalClassName
      Spotlight::ExhibitsController.prepend PrependedControllers::ExhibitsController
    end

    # TODO: May be able to remove this when spotlight is upgraded?
    if ActiveRecord.respond_to?(:yaml_column_permitted_classes) || ActiveRecord::Base.respond_to?(:yaml_column_permitted_classes)
      config.active_record.yaml_column_permitted_classes ||= []
      config.active_record.yaml_column_permitted_classes += [Symbol, ActiveSupport::HashWithIndifferentAccess]
    end
  end
end
