# frozen_string_literal: true

# Overrides Spotlight::IiifManifestPresenter in blacklight-spotlight gem to handle resources with multiple uploads
module Spotlight
  ##
  # A presenter class that provides the methods that IIIFManifest expects, as well as convenience methods
  #  that will generate a IIIFManifest object, and the actual JSON manifest from the IIIFManifest object.
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
        IiifFileSetPresenter.new(upload, width, height, controller, label)
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
  end
end
