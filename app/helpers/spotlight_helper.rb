# frozen_string_literal: true

##
# Global Spotlight helpers
module SpotlightHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  def display_exhibit_published_date(exhibit)
    return unless exhibit.published?

    exhibit.published_at? ? l(exhibit.published_at, format: :long) : 'Unknown'
  end
end
