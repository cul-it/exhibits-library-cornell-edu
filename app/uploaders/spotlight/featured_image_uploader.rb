# frozen_string_literal: true

module Spotlight
  # Overrides Spotlight::FeaturedImageUploader to inherit from Cul::ApplicationUploader for AWS S3 storage
  class FeaturedImageUploader < Cul::ApplicationUploader
    def extension_allowlist
      Spotlight::Engine.config.allowed_upload_extensions
    end
  end
end
