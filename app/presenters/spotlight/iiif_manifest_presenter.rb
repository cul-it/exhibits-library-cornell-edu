# frozen_string_literal: true

# Overrides Spotlight::IiifManifestPresenter in blacklight-spotlight gem to handle resources with multiple uploads
module Spotlight
  ##
  # A presenter class that provides the methods that IIIFManifest expects, as well as convenience methods
  #  that will generate a IIIFManifest object, and the actual JSON manifest from the IIIFManifest object.
  #  Instances of this class represent IIIF leaf nodes.  We do not currently generate manifests with interstitial
  #  nodes.
  #
  # IIIFManifest expects the following methods:  #file_set_presenters, #work_presenters, #manifest_url, #description.
  #  see: https://github.com/projecthydra-labs/iiif_manifest/blob/main/README.md
  class IiifManifestPresenter
    require 'iiif_manifest'

    delegate :uploaded_resource, to: :resource
    delegate :blacklight_config, to: :controller

    attr_accessor :resource, :controller

    def initialize(resource, controller)
      @resource = resource
      @controller = controller
    end

    # Returns an array of leaf nodes representing a resource's associated uploads.
    def file_set_presenters
      uploaded_resource.uploads.map.each_with_index do |upload, i|
        width = resource[:spotlight_full_image_width_ssm].try(:[], i)
        height = resource[:spotlight_full_image_height_ssm].try(:[], i)
        Upload.new(upload, width, height, controller, label)
      end
    end

    # This is an empty array, since we're not building manifests for works at the moment.
    def work_presenters
      []
    end

    # where this manifest can be found
    def manifest_url
      controller.spotlight.manifest_exhibit_solr_document_url(uploaded_resource.exhibit, resource)
    end

    # a description of the manifest
    def description
      resource.first(Spotlight::Engine.config.upload_description_field)
    end

    def iiif_manifest
      IIIFManifest::ManifestFactory.new(self)
    end

    def iiif_manifest_json
      iiif_manifest.to_h.to_json
    end

    private

    def presenter
      controller.view_context.document_presenter(resource)
    end

    def label
      presenter.heading
    end

    class Upload
      # The class that represents the leaf nodes must implement #id (here implemented
      # via delegation to the featured_image).
      delegate :id, to: :featured_image

      attr_accessor :upload, :width, :height, :controller, :label

      def initialize(upload, width, height, controller, label)
        @upload = upload
        @width = width
        @height = height
        @controller = controller
        @label = label
      end

      def id
        upload.id
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
        controller.riiif.info_url(upload).sub(%r{/info\.json\Z}, '')
      end
    end
  end
end
