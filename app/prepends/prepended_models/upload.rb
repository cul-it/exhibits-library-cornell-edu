# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::Resources::Upload
module PrependedModels::Upload
  # Changes relationship from belongs_to to has_many
  #   belongs_to relationship still exists (no way to override), but doesn't return anything
  Spotlight::Resources::Upload.has_many :uploads, -> { order(id: :asc) },
                                        class_name: 'Spotlight::FeaturedImage',
                                        foreign_key: 'spotlight_resource_id',
                                        validate: true

  Spotlight::Resources::Upload.accepts_nested_attributes_for :uploads

  Spotlight::Resources::Upload.validates :uploads, length: { maximum: 30 }

  # Overrides to_solr method to handle multiple uploads
  # rubocop:disable Metrics/AbcSize
  def to_solr
    return {} unless uploads.present? && uploads.all?(&:file_present?)

    upload_ids = uploads.pluck(:id)
    dimensions = upload_ids.map { |upload_id| Spotlight::Engine.config.iiif_service.info(upload_id) }

    {
      spotlight_full_image_width_ssm: dimensions.map(&:width),
      spotlight_full_image_height_ssm: dimensions.map(&:height),
      Spotlight::Engine.config.thumbnail_field => Spotlight::Engine.config.iiif_service.thumbnail_url(uploads[0]),
      Spotlight::Engine.config.iiif_manifest_field => Spotlight::Engine.config.iiif_service.manifest_url(exhibit, self),
      exhibit.blacklight_config.show.tile_source_field => uploads.map { |upload| Spotlight::Engine.config.iiif_service.info_url(upload) }
    }
  end
  # rubocop:enable Metrics/AbcSize
end
