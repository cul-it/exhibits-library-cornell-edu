# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::Resources::UploadController
module PrependedControllers::UploadController
  # Overrides create method to display more helpful error messages
  def create
    if @resource.save_and_index
      flash[:notice] = t('spotlight.resources.upload.success')
      return redirect_to new_exhibit_resource_path(@resource.exhibit, tab: :upload) if params['add-and-continue']
    else
      general_error = t('spotlight.resources.upload.error')
      specific_errors = @resource.errors.messages.values
      flash[:error] = [general_error, specific_errors].flatten.join(' ')
    end

    redirect_to admin_exhibit_catalog_path(@resource.exhibit, sort: :timestamp)
  end

  private

  # Overrides build_resource method to handle multiple uploads
  def build_resource
    @resource ||= begin
      resource = Spotlight::Resources::Upload.new exhibit: current_exhibit
      resource.attributes = resource_params
      if params[:resources_upload][:url].present?
        uploads_attributes = params[:resources_upload][:url].map { |url| { image: url } }
        resource.uploads.build(uploads_attributes)
      end

      resource
    end
  end
end
