# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in lib_prepends initializer to inject this module
# to override Riiif::VipsTransformer in riiif
module PrependedRiiif::VipsTransformer
  private

  # Chain every method in the array together and apply it to the image
  # @return [Vips::Image] - the image after all transformations
  def transform_image
    result = [crop, resize, rotate, colourspace].reduce(image) do |image, array|
      method, options = array
      # Options are blank when transformation is not required (e.g. when requesting full size)
      next image if options.blank?

      case method
      when :resize
        image.send(method, Riiif::VipsResize.new(transformation.size, image).to_vips)
      when :thumbnail_image
        # .thumbnail_image needs a positional argument (width) and keyword args (options)
        # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#thumbnail_image-instance_method
        image.send(method, options.first, **options.last)
      when :crop
        ## BEGIN CUSTOMIZATION: Use custom safe_crop method to handle out-of-bounds crop regions
        # image.send(method, *options)
        safe_crop(image, options)
        ## END CUSTOMIZATION
      else # :rotate or :colourspace
        image.send(method, options)
      end
    end
    # If result should be bitonal, set a value threshold
    # https://github.com/libvips/libvips/issues/1840
    transformation.quality == 'bitonal' ? (result > 200) : result
  end

  # Patches Riiif::VipsTransformer to handle crop regions that extend
  # outside image boundaries, padding the excess area with black instead
  # of raising Vips::Image extract_area errors.
  def safe_crop(img, options)
    offset_x, offset_y, req_w, req_h = options
    img_w = img.width
    img_h = img.height

    # Clamp to image bounds
    actual_x = [[offset_x, 0].max, img_w - 1].min
    actual_y = [[offset_y, 0].max, img_h - 1].min
    actual_w = [[offset_x + req_w, img_w].min - actual_x, 1].max
    actual_h = [[offset_y + req_h, img_h].min - actual_y, 1].max

    cropped = img.crop(actual_x, actual_y, actual_w, actual_h)

    # No padding needed if the crop was entirely within bounds
    return cropped if actual_x == offset_x &&
                      actual_y == offset_y &&
                      actual_w == req_w &&
                      actual_h == req_h

    # embed_x/embed_y: where the extracted region sits within the padded canvas
    embed_x = actual_x - offset_x  # 0 if offset_x >= 0; positive if offset_x was negative
    embed_y = actual_y - offset_y
    cropped.embed(embed_x, embed_y, req_w, req_h, extend: :black)
  end
end
