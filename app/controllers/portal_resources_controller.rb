# frozen_string_literal: true
### CUSTOMIZATION (jcolt) - new controller class for portal resources (EXPERIMENTAL)

class PortalResourcesController < ApplicationController
  helper :all
  load_and_authorize_resource :exhibit, class: Spotlight::Exhibit
  before_action :build_resource
  def create
    if @resource.save_and_index
      redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit)
    else
      render 'edit'
    end
  end

  private

    def build_resource
      @resource = begin
                    r = PortalResource.new(resource_params)
                    r.exhibit = current_exhibit
                    r
                  end
    end

    def resource_params
      params.require(:portal_resource).permit(:url, :query, :rows)
    end
end
