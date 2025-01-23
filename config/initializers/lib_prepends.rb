require 'migration/iiif'

Rails.application.config.to_prepare do
  Migration::IIIF.prepend PrependedLib::Iiif
end
