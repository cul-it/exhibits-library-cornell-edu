# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::FeaturedImage
module PrependedModels::FeaturedImage
  private

  # Overrides bust_containing_resource_caches to reflect latest schema change supporting multiple uploads
  # rubocop:disable Rails/SkipsModelValidations
  def bust_containing_resource_caches
    if Rails.version > '6'
      Spotlight::Search.where(thumbnail: self).or(Spotlight::Search.where(masthead: self)).touch_all
      Spotlight::Page.where(thumbnail: self).touch_all
      Spotlight::Exhibit.where(thumbnail: self).or(Spotlight::Exhibit.where(masthead: self)).touch_all
      Spotlight::Contact.where(avatar: self).touch_all
      Spotlight::Resources::Upload.where(id: spotlight_resource_id).touch_all
    else
      bust_containing_resource_caches_rails5
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
