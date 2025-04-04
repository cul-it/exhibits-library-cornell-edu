require 'migration/iiif'
require 'iiif_manifest'

Rails.application.config.to_prepare do
  Migration::IIIF.prepend PrependedLib::Iiif
  IIIFManifest::ManifestBuilder::ImageBuilder.prepend PrependedLib::IiifManifest::ImageBuilder
end
