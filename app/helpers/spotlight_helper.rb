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
end
