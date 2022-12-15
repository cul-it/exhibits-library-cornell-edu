# Override pattern seen in https://github.com/sul-dlss/exhibits/blob/master/app/controllers/spotlight/home_pages_controller.rb
spotlight_path = Gem::Specification.find_by_name('blacklight-spotlight').full_gem_path
require_dependency File.join(spotlight_path, 'app/controllers/spotlight/pages_controller')

module Spotlight
  # Override the upstream PagesController in order to override the pages.json implementation
  class PagesController
    # GET /exhibits/1/pageslist
    def index
      @page = CanCan::ControllerResource.new(self).send(:build_resource)

      # Using current_exhibit instead of @pages shows the full list of pages for the exhibit, including unpublished ones,
      # and not just for the superadmin role, so for regular admins and curators
      respond_to do |format|
        format.html
        format.json { render json: current_exhibit.pages.for_default_locale.published.to_json(methods: [:thumbnail_image_url]) }
      end
    end
  end
end
