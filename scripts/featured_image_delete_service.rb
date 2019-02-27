# Deletes all parts related to an uploaded file.  !!! USE WITH CAUTION.  THIS CANNOT BE UNDONE !!!

# To use to delete all parts related to a featured_image where the file did not successfully
# upload and has NULL image:
#   Run rails console: bundle exec rails c <RAILS_ENV>
#   Load the script: load 'scripts/featured_image_delete_service.rb'
#   List featured images with null image: ids = FeaturedImageDeleteService.find_null_images
#   Delete all featured images with null image: FeaturedImageDeleteService.delete_featured_images(ids)

class FeaturedImageDeleteService
  class << self
    def services
      puts 'find_null_images(limit = 1000)'
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
    def find_null_images(limit = 1000)
      puts "Featured Images where image is NULL"
      featured_image_ids = Spotlight::FeaturedImage.where(image: nil).limit(limit).map(&:id)
      delete_featured_images(featured_image_ids, pretest: true)
      featured_image_ids
    end

    # @return [Integer] the number of featured images with image=NULL'
    def count_null_images
      ids = find_null_images
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

      resources = find_resources(featured_image_id)
      solr_document_sidecars = find_solr_document_sidecars(resources)
      bookmarks = find_bookmarks(solr_document_sidecars)

      perform_pretest(featured_image, resources, solr_document_sidecars, bookmarks)
      return if pretest
      return unless delete?(featured_image, resources, auto_delete)
      perform_deletes(featured_image, resources, solr_document_sidecars, bookmarks)
    end

    private

      def perform_deletes(featured_image, resources, solr_document_sidecars, bookmarks)
        bookmarks.each { |b| b.delete }
        solr_document_sidecars.each do |d|
          Blacklight.default_index.connection.delete_by_id d.document_id
          Blacklight.default_index.connection.commit
          d.delete
        end
        resources.each { |r| r.delete }
        featured_image.remove_image!
        featured_image.delete
        puts("DELETE Complete!")
      end

      def perform_pretest(featured_image, resources, solr_document_sidecars, bookmarks)
        puts "-----------------------------------"
        puts("Will DELETE...")
        puts("    featured_image - id: #{featured_image.id}    type: #{featured_image.type}    image: #{featured_image.image}")
        resources.each { |r| puts("    resource - id: #{r.id}    type: #{r.type}    upload_id: #{r.upload_id}    exhibit_id: #{r.exhibit.id}") }
        solr_document_sidecars.each { |d| puts("    solr_document_sidecar - id: #{d.id}    document_id: #{d.document_id}    document_type: #{d.document_type}    resource_id: #{d.resource_id}    exhibit_id: #{d.exhibit_id}") }
        bookmarks.each { |b| puts("    bookmark - id: #{b.id}") }
      end

      def find_featured_image(featured_image_id)
        featured_image = Spotlight::FeaturedImage.find(featured_image_id)
        featured_image
      rescue ActiveRecord::RecordNotFound => e
        puts"-----------------------------"
        puts("featured_image NOT FOUND - id: #{featured_image_id}") if featured_image.blank?
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

      def delete? featured_image, resources, auto_delete
        return true if auto_delete && resources.blank? && featured_image.type.nil?
        puts("Do you want to perform the deletes? [Yes, no]")
        gets.chomp == 'Yes'
      end
  end
end
