require 'open-uri'
class PortalBuilder < Spotlight::SolrDocumentBuilder

  def to_solr
      solr_query = resource.url + "/select?indent=true&wt+json&q=" + resource.query + "&wt=json&rows="+resource.rows.to_s
      content = JSON.parse(open(solr_query).read)
      #byebug
      content['response']['docs'].map do |doc|
        {
            'id': doc['id'],
            'full_title_tesim': doc['title_tesim'],
            'creator_tesim': doc['creator_tesim'],
            'iiif_manifest_url_ssi': doc['content_metadata_image_iiif_info_ssm'],
            'subject_tesim': Array(doc['subject_tesim']).map{|x| x['name']}
        }
      end
    end
  end
