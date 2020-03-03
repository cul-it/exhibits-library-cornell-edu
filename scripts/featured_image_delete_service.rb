# Deletes all parts related to an uploaded file.  !!! USE WITH CAUTION.  THIS CANNOT BE UNDONE !!!

# To use to delete all parts related to a featured_image where the file did not successfully
# upload and has NULL image:
#   Run rails console: bundle exec rails c <RAILS_ENV>
#   Load the script: load 'scripts/featured_image_delete_service.rb'
#   List featured images with null image: ids = FeaturedImageDeleteService.list_null_images
#   Delete all featured images with null image: FeaturedImageDeleteService.delete_featured_images(ids)
load 'scripts/thumbnail_service.rb'

class FeaturedImageDeleteService
  class << self
    def services
      puts 'list_null_images(limit = 1000)'
      puts '  # @param [Integer] limit the number of image ids returned (default: 1000)'
      puts '  # @return [Array<Integer>] featured_image_ids - list of ids of featured images with image=NULL'
      puts 'count_null_images'
      puts '  # @return [Integer] the number of featured images with image=NULL'
      puts 'delete_featured_images(featured_image_ids, auto_delete: false, pretest: false'
      puts '  # @param [Array<Integer>] featured_image_ids - list of ids of featured images to delete'
      puts '  # @param [Boolean] auto_delete - if true, will delete without confirmation WHEN 0 resources && featured_image type is nil'
      puts '  # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete'
      puts 'delete_featured_image(featured_image_id, auto_delete: false, pretest: false'
      puts '  # @param [Integer] featured_image_id - id of featured image to delete'
      puts '  # @param [Boolean] auto_delete - if true, will delete without confirmation WHEN 0 resources && featured_image type is nil'
      puts '  # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete'
    end

    # @param [Integer] limit the number of image ids returned (default: 1000)
    # @return [Array<Integer>] featured_image_ids - list of ids of featured images with image=NULL
    def list_null_images(limit: 1000, include_thumbnails: false)
      puts "Featured Images where image is NULL"
      featured_image_ids = find_null_images(include_thumbnails: include_thumbnails, limit: limit)
      delete_featured_images(featured_image_ids, pretest: true)
      featured_image_ids
    end

    # @return [Integer] the number of featured images with image=NULL'
    def count_null_images
      ids = list_null_images
      ids.count >= 1000 ? puts('> 1000') : puts(ids.count)
    end

    # @param [Array<Integer>] featured_image_ids - list of ids of featured images to delete
    # @param [Boolean] auto_delete - if true, will delete without confirmation WHEN 0 resources && featured_image type is nil
    # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete
    def delete_featured_images(featured_image_ids, auto_delete: false, pretest: false)
      featured_image_ids.each { |id| delete_featured_image(id, auto_delete: auto_delete, pretest: pretest) }
    end

    # @param [Integer] featured_image_id - id of featured image to delete
    # @param [Boolean] auto_delete - if true, will delete without confirmation WHEN 0 resources && featured_image type is nil
    # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete
    def delete_featured_image(featured_image_id, auto_delete: false, pretest: false)
      featured_image = find_featured_image(featured_image_id)
      return if featured_image.blank?

      thumbnails = find_thumbnails(featured_image)
      resources = find_resources(featured_image_id)
      solr_document_sidecars = find_solr_document_sidecars(resources)
      bookmarks = find_bookmarks(solr_document_sidecars)

      perform_pretest(featured_image: featured_image, thumbnails: thumbnails, resources: resources,
                      solr_document_sidecars: solr_document_sidecars, bookmarks: bookmarks)
      return if pretest
      return unless delete?(featured_image, resources, thumbnails, auto_delete)
      perform_deletes(featured_image: featured_image, thumbnails: thumbnails, resources: resources,
                      solr_document_sidecars: solr_document_sidecars, bookmarks: bookmarks)
    end

    private

      def perform_deletes(featured_image:, thumbnails: [], resources: [], solr_document_sidecars: [], bookmarks: [])
        bookmarks.each { |b| b.delete }
        solr_document_sidecars.each do |d|
          Blacklight.default_index.connection.delete_by_id d.document_id
          Blacklight.default_index.connection.commit
          d.delete
        end
        resources.each { |r| r.delete }
        thumbnails.each { |t| t.delete }
        featured_image.remove_image!
        featured_image.delete
        puts("DELETE Complete!")
      end

      def perform_pretest(featured_image:, thumbnails: [], resources: [], solr_document_sidecars: [], bookmarks: [])
        puts "-----------------------------------"
        puts("Will DELETE...")
        thumbnail_text = test_for_thumbnail(featured_image)
        puts("    featured_image - id: #{featured_image.id}    type: #{featured_image.type}    image: #{featured_image.image}    iiif_tilesource: #{featured_image.iiif_tilesource}    #{thumbnail_text}")
        thumbnails.each { |t| puts("    thumbnail - id: #{t.id}     type: #{featured_image.type}    image: #{featured_image.image}    iiif_tilesource: #{t.iiif_tilesource}") }
        resources.each { |r| puts("    resource - id: #{r.id}    type: #{r.type}    upload_id: #{r.upload_id}    exhibit_id: #{r.exhibit.id}") }
        solr_document_sidecars.each { |d| puts("    solr_document_sidecar - id: #{d.id}    document_id: #{d.document_id}    document_type: #{d.document_type}    resource_id: #{d.resource_id}    exhibit_id: #{d.exhibit_id}") }
        bookmarks.each { |b| puts("    bookmark - id: #{b.id}") }
      end

      def test_for_thumbnail(featured_image)
        return '' unless ThumbnailService.thumbnail? featured_image
        "THUMBNAIL from source featured_image: #{ThumbnailService.thumbnail_source_id(featured_image)}"
      end

      # def thumbnail?(featured_image)
      #   !featured_image.iiif_tilesource.include? featured_image.id.to_s
      # end
      #
      # def thumbnail_source_id(featured_image)
      #   source_id = featured_image.iiif_tilesource.scan(/.*\/images\/(.*)\/info.json/).flatten.first
      # end

      def find_null_images(include_thumbnails: false, limit: 1000)
        null_images = Spotlight::FeaturedImage.where(image: nil).limit(limit)
        return null_images.map(&:id) if include_thumbnails
        non_thumbnail_null_images = null_images.to_a.delete_if do |nfi|
          next unless ThumbnailService.thumbnail?(nfi)
          source_id = ThumbnailService.thumbnail_source_id(nfi)
          next if source_id.blank?
          source_image = Spotlight::FeaturedImage.find(source_id)
          !source_image.image.nil?
        end
        non_thumbnail_null_images.map(&:id)
      end

      def find_featured_image(featured_image_id)
        featured_image = Spotlight::FeaturedImage.find(featured_image_id)
        featured_image
      rescue ActiveRecord::RecordNotFound => e
        puts"-----------------------------"
        puts("featured_image NOT FOUND - id: #{featured_image_id}") if featured_image.blank?
      end

      def find_thumbnails(featured_image)
        ThumbnailService.related_thumbnails(featured_image)
      end

      def find_resources(featured_image_id)
        resources = Spotlight::Resource.where(upload_id: featured_image_id)
        return [] if resources.blank?
        resources
      end

      def find_solr_document_sidecars(resources)
        return [] if resources.blank?
        all_solr_document_sidecars = []
        resources.each do |r|
          solr_document_sidecars = Spotlight::SolrDocumentSidecar.where(resource_id: r.id)
          next if solr_document_sidecars.blank?
          all_solr_document_sidecars += solr_document_sidecars
        end
        all_solr_document_sidecars.uniq!
        all_solr_document_sidecars
      end

      def find_bookmarks(solr_document_sidecars)
        return [] if solr_document_sidecars.blank?
        all_bookmarks = []
        solr_document_sidecars.each do |d|
          bookmarks = Bookmark.where(document_id: d.document_id)
          next if bookmarks.blank?
          all_bookmarks += bookmarks
        end
        all_bookmarks.uniq!
        all_bookmarks
      end

      def delete? featured_image, resources, thumbnails, auto_delete
        return true if auto_delete && resources.blank? && featured_image.type.nil? && thumbnails.blank?
        puts("Do you want to perform the deletes? [Yes, no]")
        gets.chomp == 'Yes'
      end
  end
end
