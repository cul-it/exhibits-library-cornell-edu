# frozen_string_literal: true

##
# Global Spotlight helpers
module SpotlightHelper
  include Blacklight::OpenseadragonHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  def display_exhibit_published_date(exhibit)
    return unless exhibit.published?

    exhibit.published_at? ? l(exhibit.published_at, format: :long) : 'Unknown'
  end

  def render_markdown_links(options = {})
    values = options[:value]
    return ''.html_safe unless values
    safe_html = values.map do |value|
      ERB::Util.html_escape(value).gsub(/\[([^\[]+)\]\(([^\)]+)\)/, '<a href="\2">\1</a>')
    end.join
    sanitize(safe_html)
  end

  # Overrides osd_container_class of "col-md-6" from blacklight-gallery
  def osd_container_class
    ''
  end

  # Gets initialPage for OpenSeadragon viewer
  # Document tilesources are in the format: /images/{TILESOURCE ID}/info.json
  # Selected tilesource from block is in the format: {DOMAIN}/images/{TILESOURCE ID}/info.json
  def initial_page(document, block_options)
    selected_image_tile_source = (block_options || {}).fetch(:iiif_tilesource, '')
    selected_image_tile_source = URI.parse(selected_image_tile_source).path
    doc_tile_source = document.fetch(blacklight_config.show.tile_source_field, default: [])
    doc_tile_source.find_index(selected_image_tile_source) || 0
  end
end
