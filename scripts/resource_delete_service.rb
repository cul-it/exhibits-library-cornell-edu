# Deletes all parts related to a resource, except for file.  !!! USE WITH CAUTION.  THIS CANNOT BE UNDONE !!!
# Deletes will output file location. If file is located on s3, you can delete with aws cli: aws s3 rm s3://bucket/path/to/file
# Resource will NOT be deleted if embedded on any pages on its exhibit. It will not check if resource is used in other exhibits.

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
      puts 'delete_resources(resource_ids, pretest: false, skip_checks: false)'
      puts '  # @param [Array<Integer>] resource_ids - list of ids of resources to delete'
      puts '  # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete'
      puts '  # @param [Boolean] skip_checks - if true and pretest is false, will skip confirmation checks and perform the delete'
      puts 'delete_resource(resource_id, pretest: false, skip_checks: false)'
      puts '  # @param [Integer] resource_id - id of resource to delete'
      puts '  # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete'
      puts '  # @param [Boolean] skip_checks - if true and pretest is false, will skip confirmation checks and perform the delete'
    end

    # @param [Integer] exhibit id
    # @param [Integer] limit the number of image ids returned (default: 1000)
    # @return [Array<Integer>] resource_ids - list of ids of resources with image=NULL
    def find_null_images(exhibit: nil, limit: 1000)
      puts "Resources with no associated Spotlight::FeaturedImage"
      where_clause = exhibit ? { exhibit_id:  exhibit.id } : {}
      resource_ids = Spotlight::Resources::Upload.where(where_clause).missing(:uploads).pluck(:id)
      delete_resources(resource_ids, pretest: true) # just lists info about resources when pretest: true
      resource_ids
    end

    # @param [Integer] exhibit id
    # @return [Array<Integer>] resource_ids - list of ids of resources in the exhibit
    def find_resources_for_exhibit(exhibit:, limit: 1000)
      puts "Resources for exhibit #{exhibit}"
      resource_ids = Spotlight::Resource.where(exhibit_id: exhibit).limit(limit).map(&:id)
      delete_resources(resource_ids, pretest: true) # just lists info about resources when pretest: true
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
    # @param [Boolean] skip_checks - if true and pretest is false, will skip confirmation checks and perform the delete
    def delete_resources(resource_ids, pretest: false, skip_checks: false)
      skipped = []
      deleted = []
      resource_ids.each do |id| 
        status, images = delete_resource(id, pretest:, skip_checks:)
        if status == :ok
          deleted << images
        else
          skipped << id 
        end
      end

      if !pretest
        if skipped.any?
          puts "-----------------------------------"
          puts "The following resources were NOT deleted:"
          skipped.each { |id| puts("    resource - id: #{id}") }
        end

        if deleted.any?
          puts "-----------------------------------"
          puts "The following resources were deleted from the database and solr, but not file storage:"
          deleted.each { |image| puts("    image: #{image}") }
        end
      end
    end

    # @param [Integer] resource_id - id of resource to delete
    # @param [Boolean] pretest - if true, will list what will be deleted without performing the delete
    # @param [Boolean] skip_checks - if true and pretest is false, will skip confirmation checks and perform the delete
    def delete_resource(resource_id, pretest: false, skip_checks: false)
      resource = find_resource(resource_id)
      return if resource.blank?

      featured_images = find_featured_images(resource)
      thumbnails = featured_images.each_with_object([]) { |i, arr| arr << find_thumbnails(i) }.flatten
      solr_document_sidecars = find_solr_document_sidecars(resource)
      bookmarks = find_bookmarks(solr_document_sidecars)
      pages = find_pages(resource, solr_document_sidecars)

      pretest_response = perform_pretest(resource:, featured_images:, thumbnails:,
                                         solr_document_sidecars:, bookmarks:, pages:)
      return pretest_response if pretest
      return unless delete?(skip_checks:)
      perform_deletes(resource:, featured_images:, thumbnails:,
                      solr_document_sidecars:, bookmarks:, pages:)
    end

    private

      def perform_deletes(resource:, featured_images: [], thumbnails: [], solr_document_sidecars: [], bookmarks: [], pages: [])
        if pages.any?
          puts "CANNOT DELETE - Resource is used on pages"
          return
        end

        images = featured_images.map { |i| i.image.url }.uniq
        bookmarks.each { |b| b.delete }
        solr_document_sidecars.each do |d|
          Blacklight.default_index.connection.delete_by_id d.document_id
          Blacklight.default_index.connection.commit
          d.delete
        end
        thumbnails.each { |t| t.delete }
        featured_images.each do |i|
          i.remove_image!
          i.delete
        end
        resource.delete
        puts("DELETE Complete!")

        return :ok, images
      end

      def perform_pretest(resource:, featured_images: [], thumbnails: [], solr_document_sidecars: [], bookmarks: [], pages: [])
        puts "-----------------------------------"
        puts(pages.any? ? "CANNOT DELETE - Resource is used on pages" : "CAN DELETE...")
        puts("    resource - id: #{resource.id}    type: #{resource.type}    exhibit_id: #{resource.exhibit_id}")
        featured_images.each { |i| puts("    featured image - id: #{i.id}    type: #{i.type}    image: #{i.image}") }
        thumbnails.each { |t| puts("    thumbnail - id: #{t.id}    type: #{t.type}    image: #{t.image}    iiif_tilesource: #{t.iiif_tilesource}") }
        solr_document_sidecars.each { |d| puts("    solr_document_sidecar - id: #{d.id}    document_id: #{d.document_id}    document_type: #{d.document_type}    resource_id: #{d.resource_id}    exhibit_id: #{d.exhibit_id}") }
        bookmarks.each { |b| puts("    bookmark - id: #{b.id}") }
        pages.each { |p| puts("    page - id: #{p.id}    type: #{p.type}    title: #{p.title}") }

        return :ok, featured_images.map { |i| i.image.url }.uniq unless pages.any?
      end

      def find_resource(resource_id)
        Spotlight::Resource.find(resource_id)
      rescue ActiveRecord::RecordNotFound => e
        puts"-----------------------------"
        puts("resource NOT FOUND - id: #{resource_id}")
      end

      def find_featured_images(resource)
        return [] if resource.blank?
        Spotlight::FeaturedImage.where(spotlight_resource_id: resource.id)
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

      def find_pages(resource, solr_document_sidecars)
        return [] if solr_document_sidecars.blank?
        resource.exhibit.pages.reject do |page|
          page.content.blank? || page.content.none? { |widget| widget.items.present? && widget.items.any? { |item| solr_document_sidecars.pluck(:document_id).include?(item['id']) } }
        end
      end

      def delete?(skip_checks: false)
        return true if skip_checks
        puts("Do you want to perform the deletes? [y, n]")
        gets.chomp.strip == 'y'
      end
  end
end
