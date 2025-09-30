# frozen_string_literal: true
##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config| # rubocop:disable Metrics/BlockLength
    config.show.oembed_field = :oembed_url_ssm

    config.view.gallery(document_component: Blacklight::Gallery::DocumentComponent)
    config.view.masonry(document_component: Blacklight::Gallery::DocumentComponent)
    config.view.slideshow(document_component: Blacklight::Gallery::SlideshowComponent)
    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm

    # Displays customized OSD viewer above item metadata
    config.show.embed_component = OpenseadragonEmbedComponent
    config.show.partials.insert(2, :related_pages)

    # Displays customized OSD viewer in the item embed block
    config.view.embed.partials = ['openseadragon']
    config.view.embed.embed_component = OpenseadragonEmbedComponent

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    # Blacklight 8 sets a default value to 'advanced'
    config.json_solr_path = nil
    config.header_component = HeaderComponent
    config.exhibit_navbar_component = Spotlight::ExhibitNavbarComponent
    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = 'full_title_tesim'
    config.index.thumbnail_component = ThumbnailComponent

    config.add_search_field 'all_fields', label: "All Fields"

    config.add_sort_field 'relevance', sort: 'score desc, id asc', label: "relevance"

    config.add_field_configuration_to_solr_request!

    # enable facets:
    # https://github.com/projectblacklight/spotlight/issues/1812#issuecomment-327345318
    config.add_facet_fields_to_solr_request!

    # Set which views by default only have the title displayed, e.g.,
    # config.view.gallery.title_only_by_default = true

    # Maximum number of results to show per page
    config.max_per_page = 100
    # Options for the user for number of results to show per page
    config.per_page = [10, 25, 50, 100]

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.view.masonry.title_only_by_default = true
  end
end
