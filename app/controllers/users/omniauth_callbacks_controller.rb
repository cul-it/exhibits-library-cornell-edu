# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
  skip_before_action :verify_authenticity_token, only: :saml

  def saml
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # Accept any pending invitations
      @user.accept_invitation! if @user.invited_to_sign_up?

      # Sign in
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, name: request.env["omniauth.auth"].info.netid) if is_navigational_format?
    else
      set_flash_message(:error, :failure) if is_navigational_format?
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end
end
