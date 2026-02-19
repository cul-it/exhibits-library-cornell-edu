# frozen_string_literal: true

module Spotlight
  # Overrides Spotlight::AttachmentUploader to inherit from Cul::ApplicationUploader for AWS S3 storage
  class AttachmentUploader < Cul::ApplicationUploader
  end
end
