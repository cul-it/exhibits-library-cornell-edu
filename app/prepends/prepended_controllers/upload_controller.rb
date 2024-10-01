# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::Resources::UploadController
module PrependedControllers::UploadController
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
