Rails.application.config.to_prepare do
  Riiif::VipsTransformer.prepend PrependedRiiif::VipsTransformer
end
