# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::ConfirmationsController
module PrependedControllers::ConfirmationsController
  # Overrides show action from Devise::ConfirmationsController to prevent confirming a user on a HEAD request to the
  # confirmation URL, which is used by some email clients to check the validity of the confirmation link
  def show
    if request.head?
      # HEAD request on confirmation URL must not confirm the user
      head :ok
    else
      super
    end
  end
end
