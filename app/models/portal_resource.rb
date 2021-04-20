# frozen_string_literal: true
### CUSTOMIZATION (jcolt) - new resource class for portal resources (EXPERIMENTAL)

class PortalResource < Spotlight::Resource
  self.document_builder_class = PortalBuilder
end
