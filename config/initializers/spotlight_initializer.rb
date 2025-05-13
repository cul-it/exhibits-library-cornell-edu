# frozen_string_literal: true

# ==> User model
# Note that your chosen model must include Spotlight::User mixin
# Spotlight::Engine.config.user_class = '::User'

# ==> Blacklight configuration
# Spotlight uses this upstream configuration to populate settings for the curator
# Spotlight::Engine.config.catalog_controller_class = '::CatalogController'
# Spotlight::Engine.config.default_blacklight_config = nil

# ==> Appearance configuration
# Spotlight::Engine.config.exhibit_main_navigation = [:curated_features, :browse, :about]
Spotlight::Engine.config.resource_partials = [
  # 'spotlight/resources/external_resources_form',
  'spotlight/resources/upload/form',
  'spotlight/resources/csv_upload/form'
  # 'spotlight/resources/json_upload/form'
  # 'spotlight/resources/iiif/form'
]
# Spotlight::Engine.config.external_resources_partials = ["portal_resources/form"]
# Spotlight::Engine.config.default_browse_index_view_type = :gallery
# Spotlight::Engine.config.default_contact_email = nil

# ==> IIIF configuration
# Spotlight::Engine.config.iiif_service = Spotlight::RIIIFService

# ==> Solr configuration
# Spotlight::Engine.config.writable_index = true
# Spotlight::Engine.config.solr_batch_size = 20
# Spotlight::Engine.config.filter_resources_by_exhibit = true
# Spotlight::Engine.config.autocomplete_search_field = 'autocomplete'
# Spotlight::Engine.config.default_autocomplete_params = { qf: 'id^1000 full_title_tesim^100 id_ng full_title_ng' }

# Solr field configurations
# Spotlight::Engine.config.solr_fields.prefix = ''.freeze
# Spotlight::Engine.config.solr_fields.boolean_suffix = '_bsi'.freeze
# Spotlight::Engine.config.solr_fields.string_suffix = '_ssim'.freeze
# Spotlight::Engine.config.solr_fields.text_suffix = '_tesim'.freeze
# Spotlight::Engine.config.resource_global_id_field = :"#{config.solr_fields.prefix}spotlight_resource_id#{config.solr_fields.string_suffix}"
# Spotlight::Engine.config.full_image_field = :full_image_url_ssm
# Spotlight::Engine.config.thumbnail_field = :thumbnail_url_ssm

# ==> Adding copyright and physical location to default configuration.  Note "UploadFieldConfig" needs to be preceded by "Spotlight::".
# Refer to https://github.com/projectblacklight/spotlight/blob/v3.3.0/lib/spotlight/engine.rb
Spotlight::Engine.config.upload_fields = [
  Spotlight::UploadFieldConfig.new(
     field_name: Spotlight::Engine.config.upload_description_field,
     label: -> { I18n.t(:"spotlight.search.fields.#{Spotlight::Engine.config.upload_description_field}") },
     form_field_type: :text_area,
     blacklight_options: {
      helper_method: :render_markdown_links
     }
   ),
  Spotlight::UploadFieldConfig.new(
     field_name: :spotlight_upload_attribution_tesim,
     label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_attribution_tesim') }
   ),
  Spotlight::UploadFieldConfig.new(
     field_name: :spotlight_upload_date_tesim,
     label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_date_tesim') }
   ),
  Spotlight::UploadFieldConfig.new(
     field_name: :spotlight_copyright_tesim,
     label: -> { I18n.t(:'spotlight.search.fields.spotlight_copyright_tesim') }
   ),
   Spotlight::UploadFieldConfig.new(
    field_name: :spotlight_physicallocation_tesim,
    form_field_type: :text_area,
    label: -> { I18n.t(:'spotlight.search.fields.spotlight_physicallocation_tesim') }
  )
]
# ==> Uploaded item configuration
# Spotlight::Engine.config.upload_fields = [
#   Spotlight::UploadFieldConfig.new(
#     field_name: Spotlight::Engine.config.upload_description_field,
#     label: -> { I18n.t(:"spotlight.search.fields.#{Spotlight::Engine.config.upload_description_field}") },
#     form_field_type: :text_area
#   ),
#   Spotlight::UploadFieldConfig.new(
#     field_name: :spotlight_upload_attribution_tesim,
#     label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_attribution_tesim') }
#   ),
#   Spotlight::UploadFieldConfig.new(
#     field_name: :spotlight_upload_date_tesim,
#     label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_date_tesim') }
#   )
# ]
# Spotlight::Engine.config.upload_title_field = nil # Spotlight::UploadFieldConfig.new(...)
Spotlight::Engine.config.uploader_storage = :aws if ENV['S3_KEY_ID'].present?
Spotlight::Engine.config.allowed_upload_extensions = %w(jpg jpeg png tiff tif)

# Spotlight::Engine.config.featured_image_thumb_size = [400, 300]
# Spotlight::Engine.config.featured_image_square_size = [400, 400]

# ==> Google Analytics integration
# After creating a property for your site on Google Analytics, you need to:
# a) Enable Google Analytics API in https://console.cloud.google.com/
# b) generate and download the JSON key and make it accessible to your application
# (https://console.cloud.google.com/iam-admin/iam -> Service accounts -> click on service account -> keys)
# c) set ga_property_id below to your site's property id (located in admin -> Property -> Property details upper right hand corner)
# d) Set the ga_web_property_id. (located in admin -> Data collection and modification -> Web stream details and begins with G-)
# e) (optional) set ga_date_range. This allows you throttle the dates the user can filter by.
# ga_date_range values should use a Date object i.e. (Date.new(YYYY, MM, DD)).
# ga_property_id is used for fetching analytics data from google's api, ga_web_property_id is used for sending events to GA analtyics
# ga_web_property_id will probably change in V5 to ga_measurement_id for clarity
Rails.application.config.to_prepare do
  Spotlight::Engine.config.analytics_provider = Spotlight::Analytics::Ga
  Spotlight::Engine.config.ga_json_key_path = ENV['GA_JSON_KEY_PATH']
  Spotlight::Engine.config.ga_web_property_id = ENV['GA_TRACKING_ID']
  Spotlight::Engine.config.ga_property_id = ENV['GA_PROPERTY_ID']
  Spotlight::Engine.config.ga_date_range = { 'start_date' => Date.new(2023, 04, 04), 'end_date' => nil }
  Spotlight::Engine.config.ga_analytics_options = {}
  Spotlight::Engine.config.ga_page_analytics_options = Spotlight::Engine.config.ga_analytics_options.merge(limit: 5)
  Spotlight::Engine.config.ga_search_analytics_options = Spotlight::Engine.config.ga_analytics_options.merge(limit: 11)
  Spotlight::Engine.config.ga_debug_mode = false
end

# Hide from indexing job list in exhibit dashboard
Spotlight::Engine.config.hidden_job_classes = %w[Spotlight::ReindexJob Spotlight::AddUploadsFromCsv]

# ==> Customizable settings for site tags
# When set the free text tag list field becomes multiple selection checklist
Spotlight::Engine.config.site_tags = [
  'Arts and Design',
  'Food and Agriculture',
  'Gender and Sexuality',
  'Humanities and Social Science',
  'Industry and Labor',
  'Science and Technology',
  'Cornelliana'
]

# ==> Sir Trevor Widget Configuration
# These are set by default by Spotlight's configuration,
# but you can customize them here, or in the SirTrevorRails::Block#custom_block_types method
# Spotlight::Engine.config.sir_trevor_widgets = %w(
#   Heading Text List Quote Iframe Video Oembed Rule UploadedItems Browse BrowseGroupCategories LinkToSearch
#   FeaturedPages SolrDocuments SolrDocumentsCarousel SolrDocumentsEmbed
#   SolrDocumentsFeatures SolrDocumentsGrid SearchResults
# )
#
# Page configurations made available to widgets
# Spotlight::Engine.config.page_configurations = {
#   'my-local-config': ->(context) { context.my_custom_data_path(context.current_exhibit) }
# }

themes = YAML.load_file(Rails.root.join('config', 'spotlight_themes.yml'))
default_themes = ['default'] + themes['defaults'].split
custom_themes = themes['customs'].split
Spotlight::Engine.config.exhibit_themes = default_themes + custom_themes

Exhibits::Application.config.after_initialize do
  Spotlight::Exhibit.themes_selector = ->(exhibit) do
    theme_slug = exhibit.slug
    theme_slug = theme_slug.chomp('-WIP') if theme_slug.end_with?('-WIP')
    
    if custom_themes.include?(theme_slug)
      [*default_themes, theme_slug]
    else
      default_themes
    end
  end

  Spotlight::Exhibit.send :include, Cul::ExhibitDefaults

  # Extend Spotlight's i18n_locales configuration to include Indonesian
  Spotlight::Engine.config.i18n_locales[:id] = 'Indonesian'
  Spotlight::Engine.config.i18n.available_locales += [:id]
end
