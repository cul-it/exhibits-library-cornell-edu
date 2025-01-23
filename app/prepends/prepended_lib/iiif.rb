# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in lib_prepends initializer to inject this module
# to override Migration::IIIF in spotlight

module PrependedLib::Iiif
  def copy_upload_to_featured_image(upload)
    return unless upload.exhibit # We need exhibit context to re-index, and you can't find an item not in an exhibit

    filename = upload.read_attribute_before_type_cast('url')
    filepath = "public/uploads/spotlight/resources/upload/url/#{upload.id}/#{filename}"
    return unless filename.present? && File.exist?(filepath)

    old_file = File.new(filepath)
    image = upload.uploads.create { |i| i.image.store!(old_file) }
    iiif_tilesource = Spotlight::Engine.config.iiif_service.info_url(image)
    image.update(iiif_tilesource: iiif_tilesource)
    upload.save_and_index
  end
end
