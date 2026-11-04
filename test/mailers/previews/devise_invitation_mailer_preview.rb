# frozen_string_literal: true

# Preview the invitation email on development:
# http://localhost:9292/rails/mailers/devise_invitation_mailer/exhibit_user
# http://localhost:9292/rails/mailers/devise_invitation_mailer/site_admin

class DeviseInvitationMailerPreview < ActionMailer::Preview
  def exhibit_user
    # resource must be a specific exhibit
    # all roles look the same (admin, curator, viewer)
    Devise::Mailer.invitation_instructions(create_user(Spotlight::Exhibit.first, 'viewer'), 'example-token')
  end

  def site_admin
    # resource must be the Spotlight::Site.instance so that the preview uses the correct translation keys
    Devise::Mailer.invitation_instructions(create_user(Spotlight::Site.instance, 'admin'), 'example-token')
  end

  private

  def create_user(resource, role)
    user = ::User.new(email: 'NewUser@cornell.edu')
    user.roles.build(resource: resource, role: role)
    user
  end
end
