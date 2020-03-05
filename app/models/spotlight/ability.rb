module Spotlight
  ##
  # Default Spotlight CanCan abilities
  module Ability
    include CanCan::Ability

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(user)
      user ||= Spotlight::Engine.user_class.new

      alias_action :process_import, to: :import

      if user.superadmin?
        if AccessModeService.limit_access_to_site_admins? && !user.site_admin?
          can :read, :all
        else
          can :manage, :all
        end
      end

      if AccessModeService.limit_access_to_site_admins?
        can [:read], Spotlight::Exhibit, id: user.exhibit_roles.pluck(:resource_id)
      else
        # exhibit admin
        can [:update, :import, :export, :destroy], Spotlight::Exhibit, id: user.admin_roles.pluck(:resource_id)
        can :manage, [Spotlight::BlacklightConfiguration, Spotlight::ContactEmail], exhibit_id: user.admin_roles.pluck(:resource_id)
        can :manage, Spotlight::Role, resource_id: user.admin_roles.pluck(:resource_id), resource_type: 'Spotlight::Exhibit'

        can :manage, PaperTrail::Version if user.roles.any?

        # exhibit curator
        can :manage, [
          Spotlight::Attachment,
          Spotlight::Search,
          Spotlight::Resource,
          Spotlight::Page,
          Spotlight::Contact,
          Spotlight::CustomField
        ], exhibit_id: user.exhibit_roles.pluck(:resource_id)

        can :manage, Spotlight::Lock, by: user

        can [:read, :curate, :tag], Spotlight::Exhibit, id: user.exhibit_roles.pluck(:resource_id)
      end

      # public
      can :read, Spotlight::HomePage
      can :read, Spotlight::Exhibit, published: true
      can :read, Spotlight::Page, published: true
      can :read, Spotlight::Search, published: true
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end