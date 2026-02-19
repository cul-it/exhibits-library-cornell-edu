# frozen_string_literal: true

module Cul
  # Set up a custom application uploader, to be inherited by the Spotlight uploaders
  class ApplicationUploader < CarrierWave::Uploader::Base
    storage Spotlight::Engine.config.uploader_storage

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Generate the uploader's url using AWS public url (from CarrierWave::Storage::AWSFile) if available
    def url(*args)
      file.respond_to?(:public_url) ? file.public_url : super
    end
  end
end
