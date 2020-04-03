module Spotlight
  ##
  # About pages
  class AboutPage < Spotlight::Page
    extend FriendlyId
    friendly_id :title, use: [:slugged, :scoped, :finders, :history], scope: [:exhibit, :locale]

    accepts_nested_attributes_for :thumbnail, update_only: true, reject_if: proc { |attr| attr['iiif_tilesource'].blank? }
  end
end
