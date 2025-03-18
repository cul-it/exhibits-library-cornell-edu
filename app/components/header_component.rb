class HeaderComponent < ViewComponent::Base
  attr_reader :blacklight_config, :current_user, :current_exhibit, :current_ability

  delegate :container_classes, :show_user_util_links?, to: :helpers

  # rubocop:disable Rails/SkipsModelValidations
  def initialize(blacklight_config:, current_user:, current_exhibit:, current_ability:)
    super

    @blacklight_config = blacklight_config
    @current_user = current_user
    @current_exhibit = current_exhibit
    @current_ability = current_ability
  end

  def default_nav_env_bkgnd
    Rails.env.production? ? "" : "#{Rails.env}_env"
  end

  def nav_env_bkgnd
    if ENV["BANNER_BACKGROUND"]
      case ENV["BANNER_BACKGROUND"].downcase
      when "migrating"
        "migrating"
      when "production"
        # overrides default environment based style to allow for UI style testing
        ""
      else
        default_nav_env_bkgnd
      end
    else
      default_nav_env_bkgnd
    end
  end
end
