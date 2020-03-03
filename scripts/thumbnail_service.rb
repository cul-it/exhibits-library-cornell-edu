# Deletes all parts related to an uploaded file.  !!! USE WITH CAUTION.  THIS CANNOT BE UNDONE !!!

# To use to delete all parts related to a featured_image where the file did not successfully
# upload and has NULL image:
#   Run rails console: bundle exec rails c <RAILS_ENV>
#   Load the script: load 'scripts/thumbnail_service.rb'
#   List of thumbnails related to a featured image: featured_images = ThumbnailService.related_thumbnails(featured_image)

class ThumbnailService
  class << self
    def services
      puts 'thumbnail?(test_featured_image)'
      puts '  # @param [Spotlight::FeaturedImage] the image to check whether it is a thumbnail'
      puts '  # @return [Boolean] true if passed in image is a thumbnail; otherwise, false'
      puts 'thumbnail_source_id(thumbnail_featured_image)'
      puts '  # @param [Spotlight::FeaturedImage] the thumbnail image'
      puts '  # @return [Spotlight::FeaturedImage] the image on which the thumbnail was based'
      puts 'related_thumbnails(featured_image)'
      puts '  # @param [Spotlight::FeaturedImage] a featured image'
      puts '  # @return [Array<Spotlight::FeaturedImage>] any thumbnail images based on the passed in image'
    end

    # @param [Spotlight::FeaturedImage] the image to check whether it is a thumbnail
    # @return [Boolean] true if passed in image is a thumbnail; otherwise, false
    def thumbnail?(test_featured_image)
      !test_featured_image.iiif_tilesource.include? test_featured_image.id.to_s
    end

    # @param [Spotlight::FeaturedImage] the thumbnail image
    # @return [Spotlight::FeaturedImage] the image on which the thumbnail was based
    def thumbnail_source_id(thumbnail_featured_image)
      thumbnail_featured_image.iiif_tilesource.scan(/.*\/images\/(.*)\/info.json/).flatten.first
    end
    # @param [Spotlight::FeaturedImage] a featured image
    # @return [Array<Spotlight::FeaturedImage>] any thumbnail images based on the passed in image
    def related_thumbnails(featured_image)
      Spotlight::FeaturedImage.where("iiif_tilesource like 'http%image/#{featured_image.id}/info.json'")
    end
  end
end
