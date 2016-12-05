class DplaResourcesController < ApplicationController
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
                    r = DplaResource.first_or_initialize(resource_params)
                    r.exhibit = current_exhibit
                    r
                  end
    end

    def resource_params
      params.require(:dpla_resource).permit(:url)
    end
end
