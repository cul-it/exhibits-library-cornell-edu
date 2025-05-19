module Spotlight
  class IiifFileSetPresenter
    # The class that represents the leaf nodes must implement #id (here implemented
    # via delegation to the upload).
    delegate :id, to: :upload

    attr_accessor :upload, :width, :height, :controller, :label

    def initialize(upload, width, height, controller, label)
      @upload = upload
      @width = width
      @height = height
      @controller = controller
      @label = label
    end

    # IIIFManifest expects leaf nodes to implement #display_image, which returns an instance of IIIFManifest::DisplayImage.
    def display_image
      IIIFManifest::DisplayImage.new(id,
                                    width: width&.to_i,
                                    height: height&.to_i,
                                    format: 'image/jpeg',
                                    iiif_endpoint: endpoint)
    end

    # IIIFManifest will call #to_s on each leaf node to get its respective label (not called out in README).
    def to_s
      label
    end

    private

    def endpoint
      IIIFManifest::IIIFEndpoint.new(iiif_url, profile: 'http://iiif.io/api/image/2/level2.json')
    end

    def iiif_url
      # yes this is hacky, and we are appropriately ashamed.
      Spotlight::Engine.config.iiif_service.info_url(upload)
                       .sub(%r{/info\.json\Z}, '')
    end
  end
end
