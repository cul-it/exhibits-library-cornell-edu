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

    def item_pages
      item_id = params[:item] || ""
      pages_json = JSON.parse(current_exhibit.pages.for_default_locale.published.to_json(methods: [:thumbnail_image_url]))
      exhibit_id = current_exhibit.id
      result_array = parse_pages(pages_json, item_id, exhibit_id)
      # Now get the information
      render json: { "results" => result_array }.to_json
    end

    def parse_pages(pages_json, item_id, exhibit_id)
      result_array = []
      pages_json.each do |page|
        page_id = page["id"]
        title = page["title"]
        slug = page["slug"]
        if page["content"].length.positive? && !page["content"].empty?
          content = page["content"]
          result_array.concat parse_page_content(content, item_id, page_id, title, slug)
        end
      end
      { "exhibit_id" => exhibit_id, "pages" => result_array }
    end

    def parse_page_content(content, item_id, page_id, title, slug)
      result_array = []
      content.each do |cont|
        next unless cont.key?("data") && cont["data"].key?("item") && cont["data"]["item"].keys.length
        item = cont["data"]["item"]
        item.each do |_, v|
          if v["id"] == item_id
            page_type = get_page_type(page_id)
            result_array.push({ "pageid" => page_id, "title" => title, "slug" => slug, "pagetype" => page_type })
          end
        end
      end
      result_array
    end

    def get_page_type(page_id)
      page_obj = current_exhibit.pages.find(page_id)
      page_type = "home"
      if page_obj.about_page?
        page_type = "about"
      elsif page_obj.feature_page?
        page_type = "feature"
      end
      page_type
    end
  end
end
