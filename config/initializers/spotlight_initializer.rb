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

# ==> Adding copyright to default configuration.  Note "UploadFieldConfig" needs to be preceded by "Spotlight::".
# Refer to https://github.com/projectblacklight/spotlight/blob/v3.3.0/lib/spotlight/engine.rb
Spotlight::Engine.config.upload_fields = [
  Spotlight::UploadFieldConfig.new(
     field_name: Spotlight::Engine.config.upload_description_field,
     label: -> { I18n.t(:"spotlight.search.fields.#{Spotlight::Engine.config.upload_description_field}") },
     form_field_type: :text_area
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
   )
]
# ==> Uploaded item configuration
# Spotlight::Engine.config.upload_fields = [
#   UploadFieldConfig.new(
#     field_name: config.upload_description_field,
#     label: -> { I18n.t(:"spotlight.search.fields.#{config.upload_description_field}") },
#     form_field_type: :text_area
#   ),
#   UploadFieldConfig.new(
#     field_name: :spotlight_upload_attribution_tesim,
#     label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_attribution_tesim') }
#   ),
#   UploadFieldConfig.new(
#     field_name: :spotlight_upload_date_tesim,
#     label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_date_tesim') }
#   )
# ]
# Spotlight::Engine.config.upload_title_field = nil # UploadFieldConfig.new(...)
Spotlight::Engine.config.uploader_storage = :aws if ENV['S3_KEY_ID'].present?
Spotlight::Engine.config.allowed_upload_extensions = %w(jpg jpeg png tiff tif)

# Spotlight::Engine.config.featured_image_thumb_size = [400, 300]
# Spotlight::Engine.config.featured_image_square_size = [400, 400]

# ==> Google Analytics integration
# After creating a property for your site on Google Analytics, you need to:
# a) register an OAuth service account with access to your analytics property:
#     (https://github.com/tpitale/legato/wiki/OAuth2-and-Google#registering-for-api-access)
# b) download the pkcs12 key and make it accessible to your application
# c) set ga_web_property_id below to your site's property id
# Spotlight::Engine.config.analytics_provider = Spotlight::Analytics::Ga
# Spotlight::Engine.config.ga_pkcs12_key_path = nil
Spotlight::Engine.config.ga_web_property_id = ENV['GA_TRACKING_ID']
# Spotlight::Engine.config.ga_email = nil
# Spotlight::Engine.config.ga_analytics_options = {}
# Spotlight::Engine.config.ga_page_analytics_options = config.ga_analytics_options.merge(limit: 5)
Spotlight::Engine.config.ga_debug_mode = false

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

default_themes = %w[default example]
custom_themes = %w[dr-joyce-brothers blackprint]
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
end
