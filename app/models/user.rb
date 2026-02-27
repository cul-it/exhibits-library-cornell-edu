class User < ApplicationRecord
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  include Spotlight::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable
  devise :invitable, require_password_on_accepting: false
  devise :omniauthable, omniauth_providers: %i[saml]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  ### BEGIN CUSTOMIZATIONS
  # Add check for our super super admins
  def site_admin?
    AccessModeService.site_admins.include? email
  end

  # Find or create users for omniauth logins
  def self.from_omniauth(auth)
    find_or_create_by(email: auth.info.email) do |user|
      user.provider = auth.provider
    end
  end
  ### END CUSTOMIZATION
end
