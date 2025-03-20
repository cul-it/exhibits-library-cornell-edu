# frozen_string_literal: true

# Overrides Spotlight::BulkUpdatesUploader storage configuration to prevent use of AWS S3 storage when configured as Spotlight::Engine.config.uploader_storage
# Fixes broken Spotlight processing job /app/jobs/spotlight/process_bulk_updates_csv_job.rb, which assumes local filepath (not S3) 
# Customizes storage location to tmp directory
module Spotlight
  # :nodoc:
  class BulkUpdatesUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      Rails.root.join("tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}")
    end
  end
end
