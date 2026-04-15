# frozen_string_literal: true

# Adapted from Devise::RegistrationsController
class Users::RegistrationsController < ApplicationController
  layout 'spotlight/base'
  before_action :authenticate_user!

  # GET /users/edit
  def edit
    render :edit
  end

  # DELETE /users/delete
  def destroy
    current_user.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
    flash[:notice] = t('devise.registrations.destroyed')
    redirect_to after_sign_out_path_for(:user), status: Devise.responder.redirect_status
  end
end
