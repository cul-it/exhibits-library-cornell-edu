# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::Resources::Upload
module PrependedModels::Upload
  # Changes relationship from belongs_to to has_many
  #   belongs_to relationship still exists (no way to override), but doesn't return anything
  Spotlight::Resources::Upload.has_many :uploads,
                                        class_name: 'Spotlight::FeaturedImage',
                                        foreign_key: 'spotlight_resource_id'

  Spotlight::Resources::Upload.accepts_nested_attributes_for :uploads
  
  # Overrides to_solr method to handle multiple uploads
  def to_solr
    return {} unless uploads.present? && uploads.all?(&:file_present?)

    spotlight_routes = Spotlight::Engine.routes.url_helpers
    riiif = Riiif::Engine.routes.url_helpers

    upload_ids = uploads.pluck(:id)
    dimensions = upload_ids.map { |upload_id| Riiif::Image.new(upload_id).info }

    {
      spotlight_full_image_width_ssm: dimensions.map(&:width),
      spotlight_full_image_height_ssm: dimensions.map(&:height),
      Spotlight::Engine.config.thumbnail_field => riiif.image_path(uploads[0], size: '!400,400'),
      Spotlight::Engine.config.iiif_manifest_field => spotlight_routes.manifest_exhibit_solr_document_path(exhibit, compound_id),
      exhibit.blacklight_config.show.tile_source_field => uploads.map { |upload| riiif.info_path(upload) }
    }
  end
end
