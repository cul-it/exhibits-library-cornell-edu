require 'prepends/iiif'

Rails.application.config.to_prepare do
  Migration::IIIF.prepend IIIFPrepend
end
