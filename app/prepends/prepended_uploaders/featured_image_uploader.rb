# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::FeaturedImageUploader
module PrependedUploaders::FeaturedImageUploader
  # Carrierwave validation to check file size is between provided range
  # File is first uploaded to tmp, then removed if validation fails
  def size_range
    1.byte..10.megabytes
  end
end
