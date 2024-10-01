# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::CatalogController
module PrependedControllers::CatalogController
  private

  # Overrides strong params to permit url as an array
  def solr_document_params
    params.require(:solr_document).permit(:exhibit_tag_list,
                                          uploaded_resource: [url: []],
                                          sidecar: [:public, data: [editable_solr_document_params]])
  end
end
