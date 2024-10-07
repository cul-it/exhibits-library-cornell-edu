##
# Mixin for SolrDocuments backed by exhibit-specific resources
# Overrides Spotlight::SolrDocument::UploadedResource to handle multiple uploads
module Cul
  module UploadedResource
    extend ActiveSupport::Concern

    def to_openseadragon(*_args)
      uploaded_resource.uploads.map(&:iiif_tilesource) if uploaded_resource&.uploads.present?
    end
  end
end
