# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in lib_prepends initializer to inject this module
# to override IIIFManifest::ManifestBuilder::ImageBuilder in iiif_manifest

module PrependedLib::IiifManifest::ImageBuilder
  # Hack to set annotation ['@id'] in manifest so that existing multi-image selection spotlight logic works with generated iiif manifest
  def apply(canvas)
    annotation['@id'] = canvas['@id'].gsub('/canvas/', '/annotation/')
    annotation['on'] = canvas['@id']
    canvas['width'] = annotation.resource['width']
    canvas['height'] = annotation.resource['height']
    canvas.images += [annotation]
  end
end
