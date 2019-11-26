# Deletes all parts related to a resource.  !!! USE WITH CAUTION.  THIS CANNOT BE UNDONE !!!

# To use to delete all parts related to a resource with a null image:
#   Run rails console: bundle exec rails c <RAILS_ENV>
#   Load the script: load 'scripts/resource_delete_service.rb'
#   List resources with null image: ids = ResourceDeleteService.find_null_images
#   Delete all resources with null image: ResourceDeleteService.delete_resources(ids)
load 'scripts/thumbnail_service.rb'

class ResourceDeleteService
  class << self
    def services
      puts 'find_null_images(exhibit: nil, limit: 1000)'
      puts '  # @param [Integer] exhibit id'
      puts '  # @param [Integer] limit the number of image ids returned (default: 1000)'
      puts '  # @return [Array<Integer>] resource_ids - list of ids of resources with image=NULL'
      puts 'find_resources_for_exhibit(exhibit:, limit: 1000)'
      puts '  # @param [Integer] exhibit id'
      puts '  # @return [Array<Integer>] resource_ids - list of ids of resources with image=NULL'
      puts 'find_resources_without_an_exhibit'
      puts 'count_null_images'
      puts '  # @return [Integer] the number of resources with image=NULL'
      puts 'delete_resources(resource_ids, pretest: false'
      puts '  # @param [Array<Integer>] resource_ids - list of ids of resources to delete'
      puts '  # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete'
      puts 'delete_resource(resource_id, pretest: false'
      puts '  # @param [Integer] resource_id - id of resource to delete'
      puts '  # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete'
    end

    # @param [Integer] exhibit id
    # @param [Integer] limit the number of image ids returned (default: 1000)
    # @return [Array<Integer>] resource_ids - list of ids of resources with image=NULL
    def find_null_images(exhibit: nil, limit: 1000)
      puts "Resources where upload_id is NULL"
      where_clause = { upload_id: nil }
      where_clause[:exhibit_id] = exhibit if exhibit
      resource_ids = Spotlight::Resource.where(where_clause).limit(limit).map(&:id)
      delete_resources(resource_ids, pretest: true)
      resource_ids
    end

    # @param [Integer] exhibit id
    # @return [Array<Integer>] resource_ids - list of ids of resources with image=NULL
    def find_resources_for_exhibit(exhibit:, limit: 1000)
      puts "Resources for exhibit #{exhibit}"
      resource_ids = Spotlight::Resource.where(exhibit_id: exhibit).limit(limit).map(&:id)
      delete_resources(resource_ids, pretest: true)
      resource_ids
    end

    # @return [Array<Integer>] resource_ids - list of ids of resources with image=NULL
    def find_resources_without_an_exhibit
      puts "Resources without an exhibit"
      all_resource_exhibit_ids = Spotlight::Resource.all.map(&:exhibit_id).uniq.sort
      all_exhibit_ids = Spotlight::Exhibit.all.map(&:id).sort
      resource_exhibits_that_donot_exist = all_resource_exhibit_ids - all_exhibit_ids
      resource_exhibits_that_donot_exist.each do |exhibit_id|
        ExhibitService.counts exhibit_id
      end
    end

    # @return [Integer] the number of resources with image=NULL'
    def count_null_images
      ids = find_null_images
      ids.count >= 1000 ? puts('> 1000') : puts(ids.count)
    end

    # @param [Array<Integer>] resource_ids - list of ids of resources to delete
    # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete
    def delete_resources(resource_ids, pretest: false)
      resource_ids.each { |id| delete_resource(id, pretest: pretest) }
    end

    # @param [Integer] resource_id - id of resource to delete
    # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete
    def delete_resource(resource_id, pretest: false)
      resource = find_resource(resource_id)
      return if resource.blank?

      featured_image = find_featured_image(resource)
      thumbnails = find_thumbnails(featured_image)
      solr_document_sidecars = find_solr_document_sidecars(resource)
      bookmarks = find_bookmarks(solr_document_sidecars)

      perform_pretest(resource: resource, featured_image: featured_image, thumbnails: thumbnails,
                      solr_document_sidecars: solr_document_sidecars, bookmarks: bookmarks)
      return if pretest
      return unless delete?
      perform_deletes(resource: resource, featured_image: featured_image, thumbnails: thumbnails,
                      solr_document_sidecars: solr_document_sidecars, bookmarks: bookmarks)
    end

    private

      def perform_deletes(resource:, featured_image:, thumbnails: [], solr_document_sidecars: [], bookmarks: [])
        bookmarks.each { |b| b.delete }
        solr_document_sidecars.each do |d|
          Blacklight.default_index.connection.delete_by_id d.document_id
          Blacklight.default_index.connection.commit
          d.delete
        end
        thumbnails.each { |t| t.delete }
        featured_image.remove_image! if featured_image
        featured_image.delete if featured_image
        resource.delete
        puts("DELETE Complete!")
      end

      def perform_pretest(resource:, featured_image:, thumbnails: [], solr_document_sidecars: [], bookmarks: [])
        puts "-----------------------------------"
        puts("Will DELETE...")
        puts("    resource - id: #{resource.id}    type: #{resource.type}    upload_id: #{resource.upload_id}    exhibit_id: #{resource.exhibit_id}")
        puts("    featured image - id: #{featured_image.id}    type: #{featured_image.type}    image: #{featured_image.image}") if featured_image
        Spotlight::Resource.where(upload_id: resource.upload_id).each do |r|
          next if r.id == resource.id || resource.upload_id.blank?
          puts("       ALT resource with upload_id: #{resource.upload_id}   resource - id: #{r.id}    exhibit_id: #{r.exhibit_id}")
        end unless resource.upload_id.blank?
        thumbnails.each { |t| puts("    thumbnail - id: #{t.id}    type: #{t.type}    image: #{t.image}    iiif_tilesource: #{t.iiif_tilesource}") }
        solr_document_sidecars.each { |d| puts("    solr_document_sidecar - id: #{d.id}    document_id: #{d.document_id}    document_type: #{d.document_type}    resource_id: #{d.resource_id}    exhibit_id: #{d.exhibit_id}") }
        bookmarks.each { |b| puts("    bookmark - id: #{b.id}") }
      end

      def find_resource(resource_id)
        Spotlight::Resource.find(resource_id)
      rescue ActiveRecord::RecordNotFound => e
        puts"-----------------------------"
        puts("resource NOT FOUND - id: #{resource_id}")
      end

      def find_featured_image(resource)
        return nil if resource.blank?
        featured_image_id = resource.upload_id
        return nil if featured_image_id.blank?
        Spotlight::FeaturedImage.find(featured_image_id)
      end

      def find_thumbnails(featured_image)
        return [] if featured_image.blank? || featured_image.id.blank?
        Spotlight::FeaturedImage.where("iiif_tilesource like 'http%/images/#{featured_image.id}/info.json'")
      end

      def find_solr_document_sidecars(resource)
        return [] if resource.blank?
        Spotlight::SolrDocumentSidecar.where(resource_id: resource.id)
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

      def delete?
        puts("Do you want to perform the deletes? [Yes, no]")
        gets.chomp == 'Yes'
      end
  end
end
