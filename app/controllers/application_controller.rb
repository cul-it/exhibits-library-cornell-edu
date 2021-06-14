# TODO: UPGRADE - evaluate diffs from Spotlight base app
class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  layout :determine_layout if respond_to? :layout

  # TODO: UPGRADE - remove? following line does not exist
  protect_from_forgery with: :exception
end
