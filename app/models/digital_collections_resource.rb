class DigitalCollectionsResource < Spotlight::Resource
  # TODO: What is this indexing pipeline
  def self.indexing_pipeline
    @indexing_pipeline ||= super.dup.tap do |pipeline|
      pipeline.transforms = [Spotlight::Etl::Sources::SourceMethodSource(:to_solr)] + pipeline.transforms

      # PR for implementing an ETL-like pattern for indexing documents
      #   https://github.com/projectblacklight/spotlight/pull/2625
      # # if, say, you wanted to feed the transform with multiple source documents
      # #   (here, by calling the `#iiif_manifest` method on the DlmeJson instance);
      # #   previously, the #to_solr method of the document builder would have done this extraction
      # # pipeline.sources = [Spotlight::Etl::Sources::SourceMethodSource(:iiif_manifests)]
      # pipeline.transforms = [
      #   ->(data, p) { data.merge(DlmeJsonResourceBuilder.new(p.context.resoure).to_solr) }
      # ]

      # Spotlight::Resource::IiifHarvester
      # pipeline.sources = [Spotlight::Etl::Sources::SourceMethodSource(:iiif_manifests)]
      # pipeline.transforms = [
      #   ->(data, p) { data.merge(p.source.to_solr(exhibit: p.context.resource.exhibit)) }
      # ] + pipeline.transforms

      # Spotlight::Resource::JsonUpload
      # pipeline.sources = [Spotlight::Etl::Sources::StoredData]
      # pipeline.transforms = [
      #   Spotlight::Etl::Transforms::IdentityTransform
      # ] + pipeline.transforms
    end
  end

  def to_solr
    # TODO
  end
end
