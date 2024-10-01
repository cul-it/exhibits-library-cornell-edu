# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  include Spotlight::SolrDocument

  include Spotlight::SolrDocument::AtomicUpdates

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Overrides Spotlight::SolrDocument::UploadedResource included in Spotlight::SolrDocument to handle multiple uploads
  use_extension(Cul::UploadedResource, &:uploaded_resource?)

  # If no uploads, create an upload for each url
  # If more uploads than new urls, delete extra uploads
  # Reindex resource to update thumbnail and etc
  # Called from SolrDocument#update
  def update_exhibit_resource(resource_attributes)
    return unless resource_attributes && resource_attributes['url'].present?

    urls = resource_attributes['url']
    current_uploads = uploaded_resource.uploads
    current_upload_ids = current_uploads.pluck(:id)
    upload_updates = Hash[[*0..(urls.count-1)].zip(current_upload_ids)]
    new_uploads_attributes = []
    urls.each_with_index do |url, i|
      upload_id = upload_updates[i]
      if upload_id.nil?
        new_uploads_attributes << { image: url }
      else
        # Update existing uploads
        current_uploads.find(upload_id).update(image: url)
      end
    end

    # Build new uploads
    uploaded_resource.uploads.build(new_uploads_attributes)

    # Delete extra uploads
    extra_upload_ids = current_upload_ids - upload_updates.values
    uploaded_resource.uploads.where(id: extra_upload_ids).destroy_all

    # Save uploaded_resource and any new uploads and reindex
    uploaded_resource.save_and_index
  end
end
