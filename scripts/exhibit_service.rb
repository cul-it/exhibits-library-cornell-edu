# List all database entries related to an exhibit:

# To use:
#   Run rails console: bundle exec rails c <RAILS_ENV>
#   Load the script: load 'scripts/exhibit_service.rb'
#   List resources with null image: ExhibitService.database_entries _ID_
load 'scripts/thumbnail_service.rb'

class ExhibitService
  class << self
    def services
      puts 'database_entries'
      puts '  # @param [Integer] exhibit id'
      puts 'counts'
      puts '  # @param [Integer] exhibit id'
    end

    # @param [Integer] exhibit id
    def counts(id)
      puts "====================================================="
      begin
        exhibit = Spotlight::Exhibit.find(id)
        puts "Database entries related to exhibit #{id} -- title: #{exhibit.title}   slug: #{exhibit.slug}   featured_image: #{exhibit.featured_image}   masthead: #{exhibit.masthead_id}   thumbnail: #{exhibit.thumbnail_id}"
      rescue ActiveRecord::RecordNotFound => e
        puts "EXHIBIT DOES NOT EXIST: #{id}"
        puts "Looking for related database entries that may be hanging around"
      end
      puts "====================================================="
      count_resources(id)
      count_solr_document_sidecars(id)
      count_searches(id)
      count_filters(id)
      count_main_navigations(id)
      count_pages(id)
      count_attachments(id)
      count_blacklight_configurations(id)
      count_contact_emails(id)
      count_contacts(id)
      count_custom_fields(id)
      count_reindexing_log_entries(id)
      count_slugs(id)
      puts "====================================================="
    end

    # @param [Integer] exhibit id
    def database_entries(id)
      puts "====================================================="
      begin
        exhibit = Spotlight::Exhibit.find(id)
        puts "Database entries related to exhibit #{id} -- title: #{exhibit.title}   slug: #{exhibit.slug}   featured_image: #{exhibit.featured_image}   masthead: #{exhibit.masthead_id}   thumbnail: #{exhibit.thumbnail_id}"
      rescue ActiveRecord::RecordNotFound => e
        puts "EXHIBIT DOES NOT EXIST: #{id}"
        puts "Looking for related database entries that may be hanging around"
      end
      puts "====================================================="
      list_resources(id)
      list_solr_document_sidecars(id)
      list_searches(id)
      list_filters(id)
      list_main_navigations(id)
      list_pages(id)
      list_attachments(id)
      list_blacklight_configurations(id)
      list_contact_emails(id)
      list_contacts(id)
      list_custom_fields(id)
      list_reindexing_log_entries(id)
      list_slugs(id)
    end

    private

      def count_attachments exhibit_id
        puts "Attachments: #{Spotlight::Attachment.where(exhibit_id: exhibit_id).count}"
      end

      def list_attachments exhibit_id
        puts 'Attachments:'
        Spotlight::Attachment.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   file: #{r.file}"
        end
        puts '------------'
      end

      def count_blacklight_configurations exhibit_id
        puts "Blacklight Configurations: #{Spotlight::BlacklightConfiguration.where(exhibit_id: exhibit_id).count}"
      end

      def list_blacklight_configurations exhibit_id
        puts 'Blacklight Configurations:'
        Spotlight::BlacklightConfiguration.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}"
        end
        puts '------------'
      end

      def count_contact_emails exhibit_id
        puts "Contact Emails: #{Spotlight::ContactEmail.where(exhibit_id: exhibit_id).count}"
      end

      def list_contact_emails exhibit_id
        puts 'Contact Emails:'
        Spotlight::ContactEmail.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   email: #{r.email}"
        end
        puts '------------'
      end

      def count_contacts exhibit_id
        puts "Contacts: #{Spotlight::Contact.where(exhibit_id: exhibit_id).count}"
      end

      def list_contacts exhibit_id
        puts 'Contacts:'
        Spotlight::Contact.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   name: #{r.name}   avatar: #{r.avatar_id}"
        end
        puts '------------'
      end

      def count_custom_fields exhibit_id
        puts "Custom Fields: #{Spotlight::CustomField.where(exhibit_id: exhibit_id).count}"
      end

      def list_custom_fields exhibit_id
        puts 'Custom Fields:'
        Spotlight::CustomField.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   field: #{r.field}"
        end
        puts '------------'
      end

      def count_filters exhibit_id
        puts "Filters: #{Spotlight::Filter.where(exhibit_id: exhibit_id).count}"
      end

      def list_filters exhibit_id
        puts 'Filters:'
        Spotlight::Filter.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   field: #{r.field}"
        end
        puts '------------'
      end

      def count_main_navigations exhibit_id
        puts "Main Navigation: #{Spotlight::MainNavigation.where(exhibit_id: exhibit_id).count}"
      end

      def list_main_navigations exhibit_id
        puts 'Main Navigation:'
        Spotlight::MainNavigation.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   label: #{r.label}   nav_type: #{r.nav_type}"
        end
        puts '------------'
      end

      def count_pages exhibit_id
        puts "Pages: #{Spotlight::Page.where(exhibit_id: exhibit_id).count}"
      end

      def list_pages exhibit_id
        puts 'Pages:'
        Spotlight::Page.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   title: #{r.title}   type: #{r.type}   parent_page: #{r.parent_page_id}   thumbnail: #{r.thumbnail_id}"
        end
        puts '------------'
      end

      def count_reindexing_log_entries exhibit_id
        puts "Reindexing Log Entries: #{Spotlight::ReindexingLogEntry.where(exhibit_id: exhibit_id).count}"
      end

      def list_reindexing_log_entries exhibit_id
        puts 'Reindexing Log Entries:'
        Spotlight::ReindexingLogEntry.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   start_time: #{r.start_time}   end_time: #{r.end_time}"
        end
        puts '------------'
      end

      def count_resources exhibit_id
        puts "Resources: #{Spotlight::Resource.where(exhibit_id: exhibit_id).count}"
      end

      def list_resources exhibit_id
        puts 'Resources:'
        Spotlight::Resource.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   type: #{r.type}   upload_id: #{r.upload_id}"
          if r.upload_id
            image = Spotlight::FeaturedImage.find(r.upload_id)
            puts "     Featured Image: #{image.id}   type: #{image.type}   source: #{image.source}" if image
            Spotlight::Resource.where(upload_id: r.upload_id).each do |alt_r|
              puts "     ALT RESOURCE: exhibit: #{alt_r.exhibit_id}   id: #{alt_r.id}   type: #{alt_r.type}   upload_id: #{alt_r.upload_id}" unless alt_r.id == r.id
            end
          end
        end
        puts '------------'
      end

      def count_searches exhibit_id
        puts "Searches: #{Spotlight::Search.where(exhibit_id: exhibit_id).count}"
      end

      def list_searches exhibit_id
        puts 'Searches:'
        Spotlight::Search.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   title: #{r.title}   published: #{r.published}   featured_item: #{r.featured_item_id}   masthead: #{r.masthead_id}   thumbnail: #{r.thumbnail_id}"
        end
        puts '------------'
      end

      def count_solr_document_sidecars exhibit_id
        puts "Solr Document Sidecars: #{Spotlight::SolrDocumentSidecar.where(exhibit_id: exhibit_id).count}"
      end

      def list_solr_document_sidecars exhibit_id
        puts 'Solr Document Sidecars:'
        Spotlight::SolrDocumentSidecar.where(exhibit_id: exhibit_id).each do |r|
          puts "  exhibit: #{r.exhibit_id}   id: #{r.id}   public: #{r.public}   document: #{r.document_id}   document_type: #{r.document_type}   resource: #{r.resource_id}   resource_type: #{r.resource_type}"
          if r.resource_id
            Spotlight::SolrDocumentSidecar.where(resource_id: r.resource_id).each do |alt_r|
              puts "     ALT SIDECAR: exhibit: #{alt_r.exhibit_id}   id: #{alt_r.id}   public: #{alt_r.public}   document: #{alt_r.document_id}   document_type: #{alt_r.document_type}   resource: #{alt_r.resource_id}   resource_type: #{alt_r.resource_type}" unless alt_r.id == r.id
            end
          end
        end
        puts '------------'
      end

      def count_slugs exhibit_id
        puts "Friendly ID Slugs: #{FriendlyId::Slug.where(scope: "exhibit_id:#{exhibit_id}").count}"
      end

      def list_slugs exhibit_id
        puts 'Friendly ID Slugs:'
        FriendlyId::Slug.where(scope: "exhibit_id:#{exhibit_id}").each do |slug|
          puts "  exhibit: #{slug.scope}   id: #{slug.id}   slug: #{slug.slug}   type: #{slug.sluggable_type}"
        end
        puts '------------'
      end
  end
end
