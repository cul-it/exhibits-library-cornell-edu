class User < ApplicationRecord
  # TODO: UPGRADE - Verified

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  include Spotlight::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  ### BEGIN CUSTOMIZATION (elr) - add check for our super super admins
  def site_admin?
    AccessModeService.site_admins.include? email
  end
  ### END CUSTOMIZATION
end
