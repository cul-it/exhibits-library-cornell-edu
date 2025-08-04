class ChangePrimaryKeyToBigint < ActiveRecord::Migration[8.0]
  # Update all primary keys and references to bigint to ensure environments match
  # Does not update any foreign keys that are explicitly set to integer in underlying gems
  def up
    remove_foreign_key :spotlight_featured_images, :spotlight_resources

    change_column :bookmarks, :id, :bigint
    change_column :friendly_id_slugs, :id, :bigint
    change_column :searches, :id, :bigint
    change_column :spotlight_attachments, :id, :bigint
    change_column :spotlight_attachments, :exhibit_id, :bigint
    change_column :spotlight_blacklight_configurations, :id, :bigint
    change_column :spotlight_blacklight_configurations, :exhibit_id, :bigint
    change_column :spotlight_bulk_updates, :id, :bigint
    change_column :spotlight_bulk_updates, :exhibit_id, :bigint
    change_column :spotlight_contact_emails, :id, :bigint
    change_column :spotlight_contact_emails, :exhibit_id, :bigint
    change_column :spotlight_contacts, :id, :bigint
    change_column :spotlight_contacts, :exhibit_id, :bigint
    change_column :spotlight_custom_fields, :id, :bigint
    change_column :spotlight_custom_fields, :exhibit_id, :bigint
    change_column :spotlight_custom_search_fields, :id, :bigint
    change_column :spotlight_custom_search_fields, :exhibit_id, :bigint
    change_column :spotlight_events, :id, :bigint
    change_column :spotlight_events, :exhibit_id, :bigint
    change_column :spotlight_events, :resource_id, :bigint
    change_column :spotlight_exhibits, :id, :bigint
    change_column :spotlight_featured_images, :id, :bigint
    change_column :spotlight_featured_images, :spotlight_resource_id, :bigint
    change_column :spotlight_filters, :id, :bigint
    change_column :spotlight_filters, :exhibit_id, :bigint
    change_column :spotlight_groups, :id, :bigint
    change_column :spotlight_groups, :exhibit_id, :bigint
    change_column :spotlight_groups_members, :group_id, :bigint
    change_column :spotlight_groups_members, :member_id, :bigint
    change_column :spotlight_job_trackers, :id, :bigint
    change_column :spotlight_job_trackers, :on_id, :bigint
    change_column :spotlight_job_trackers, :resource_id, :bigint
    change_column :spotlight_job_trackers, :user_id, :bigint
    change_column :spotlight_languages, :id, :bigint
    change_column :spotlight_languages, :exhibit_id, :bigint
    change_column :spotlight_locks, :id, :bigint
    change_column :spotlight_locks, :on_id, :bigint
    change_column :spotlight_locks, :by_id, :bigint
    change_column :spotlight_main_navigations, :id, :bigint
    change_column :spotlight_main_navigations, :exhibit_id, :bigint
    change_column :spotlight_pages, :id, :bigint
    change_column :spotlight_pages, :exhibit_id, :bigint
    change_column :spotlight_pages, :default_locale_page_id, :bigint
    change_column :spotlight_reindexing_log_entries, :id, :bigint
    change_column :spotlight_reindexing_log_entries, :exhibit_id, :bigint
    change_column :spotlight_reindexing_log_entries, :user_id, :bigint
    change_column :spotlight_resources, :id, :bigint
    change_column :spotlight_resources, :exhibit_id, :bigint
    change_column :spotlight_roles, :id, :bigint
    change_column :spotlight_roles, :user_id, :bigint
    change_column :spotlight_searches, :id, :bigint
    change_column :spotlight_searches, :exhibit_id, :bigint
    change_column :spotlight_sites, :id, :bigint
    change_column :spotlight_sites, :masthead_id, :bigint
    change_column :spotlight_solr_document_sidecars, :id, :bigint
    change_column :spotlight_solr_document_sidecars, :exhibit_id, :bigint
    change_column :taggings, :id, :bigint
    change_column :taggings, :tag_id, :bigint
    change_column :taggings, :tagger_id, :bigint
    change_column :tags, :id, :bigint
    change_column :translations, :id, :bigint
    change_column :translations, :exhibit_id, :bigint
    change_column :users, :id, :bigint
    change_column :users, :invited_by_id, :bigint
    change_column :versions, :id, :bigint

    add_foreign_key :spotlight_featured_images, :spotlight_resources
  end

  def down
    remove_foreign_key :spotlight_featured_images, :spotlight_resources

    id_data_type = Rails.env.test? || Rails.env.development? ? :bigint : :integer
    change_column :bookmarks, :id, id_data_type
    change_column :friendly_id_slugs, :id, id_data_type
    change_column :searches, :id, id_data_type
    change_column :spotlight_attachments, :id, id_data_type
    change_column :spotlight_attachments, :exhibit_id, id_data_type
    change_column :spotlight_blacklight_configurations, :id, id_data_type
    change_column :spotlight_blacklight_configurations, :exhibit_id, id_data_type
    change_column :spotlight_bulk_updates, :id, id_data_type
    change_column :spotlight_bulk_updates, :exhibit_id, id_data_type
    change_column :spotlight_contact_emails, :id, id_data_type
    change_column :spotlight_contact_emails, :exhibit_id, id_data_type
    change_column :spotlight_contacts, :id, id_data_type
    change_column :spotlight_contacts, :exhibit_id, id_data_type
    change_column :spotlight_custom_fields, :id, id_data_type
    change_column :spotlight_custom_fields, :exhibit_id, id_data_type
    change_column :spotlight_custom_search_fields, :id, id_data_type
    change_column :spotlight_custom_search_fields, :exhibit_id, id_data_type
    change_column :spotlight_events, :id, id_data_type
    change_column :spotlight_events, :exhibit_id, id_data_type
    change_column :spotlight_events, :resource_id, id_data_type
    change_column :spotlight_exhibits, :id, id_data_type
    change_column :spotlight_featured_images, :id, id_data_type
    change_column :spotlight_featured_images, :spotlight_resource_id, id_data_type
    change_column :spotlight_filters, :id, id_data_type
    change_column :spotlight_filters, :exhibit_id, id_data_type
    change_column :spotlight_groups, :id, id_data_type
    change_column :spotlight_groups, :exhibit_id, id_data_type
    change_column :spotlight_groups_members, :group_id, id_data_type
    change_column :spotlight_groups_members, :member_id, id_data_type
    change_column :spotlight_job_trackers, :id, id_data_type
    change_column :spotlight_job_trackers, :on_id, id_data_type
    change_column :spotlight_job_trackers, :resource_id, id_data_type
    change_column :spotlight_job_trackers, :user_id, id_data_type
    change_column :spotlight_languages, :id, id_data_type
    change_column :spotlight_languages, :exhibit_id, id_data_type
    change_column :spotlight_locks, :id, id_data_type
    change_column :spotlight_locks, :on_id, id_data_type
    change_column :spotlight_locks, :by_id, id_data_type
    change_column :spotlight_main_navigations, :id, id_data_type
    change_column :spotlight_main_navigations, :exhibit_id, id_data_type
    change_column :spotlight_pages, :id, id_data_type
    change_column :spotlight_pages, :exhibit_id, id_data_type
    change_column :spotlight_pages, :default_locale_page_id, id_data_type
    change_column :spotlight_reindexing_log_entries, :id, id_data_type
    change_column :spotlight_reindexing_log_entries, :exhibit_id, id_data_type
    change_column :spotlight_reindexing_log_entries, :user_id, id_data_type
    change_column :spotlight_resources, :id, id_data_type
    change_column :spotlight_resources, :exhibit_id, id_data_type
    change_column :spotlight_roles, :id, id_data_type
    change_column :spotlight_roles, :user_id, id_data_type
    change_column :spotlight_searches, :id, id_data_type
    change_column :spotlight_searches, :exhibit_id, id_data_type
    change_column :spotlight_sites, :id, id_data_type
    change_column :spotlight_sites, :masthead_id, id_data_type
    change_column :spotlight_solr_document_sidecars, :id, id_data_type
    change_column :spotlight_solr_document_sidecars, :exhibit_id, id_data_type
    change_column :taggings, :id, id_data_type
    change_column :taggings, :tag_id, id_data_type
    change_column :taggings, :tagger_id, id_data_type
    change_column :tags, :id, id_data_type
    change_column :translations, :id, id_data_type
    change_column :translations, :exhibit_id, id_data_type
    change_column :users, :id, id_data_type
    change_column :users, :invited_by_id, id_data_type
    change_column :versions, :id, id_data_type

    add_foreign_key :spotlight_featured_images, :spotlight_resources
  end
end

