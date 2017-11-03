class PortalBuilder < Spotlight::SolrDocumentBuilder
    def to_solr
      super.tap do |solr_hash|
      add_content solr_hash
      add_sidecar_fields solr_hash

    end
end


def add_content(solr_hash)
  content = JSON.parse(open(resource.url).read)
  content['response']['docs'].map do |doc|

          solr_hash[exhibit.blacklight_config.document_model.unique_key.to_sym]  = doc['id']
          solr_hash[:full_title_tesim] = doc['title_tesim']
          solr_hash[Spotlight::Engine.config.thumbnail_field] = doc['media_URL_size_2_tesim']
          solr_hash[:creator_ssim] = doc['creator_tesim']
          solr_hash[:iiif_manifest_url_ssi] = doc['content_metadata_image_iiif_info_ssm']

  end
end

def add_sidecar_fields(solr_hash)
      solr_hash.merge! resource.sidecar.to_solr
    end

end
