module ApplicationHelper
  include SpotlightHelper

  # Used in the header navbar to determine if the visitor should see the util links 
  # (change language, user account options, contact form)
  def show_user_util_links?(current_user, current_exhibit, current_ability)
    !!(current_user || (current_exhibit && (show_contact_form? || current_exhibit.languages.accessible_by(current_ability).any?)))
  end
end