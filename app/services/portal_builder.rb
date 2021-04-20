# frozen_string_literal: true
### CUSTOMIZATION (jcolt) - new service class creates solr documents for portal resources (EXPERIMENTAL)

require 'open-uri'
class PortalBuilder < Spotlight::SolrDocumentBuilder
  def to_solr # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    solr_query = resource.url + "/select?indent=true&wt+json&q=" + resource.query + "&wt=json&rows=" + resource.rows.to_s
    content = JSON.parse(open(solr_query).read)
    content['response']['docs'].map do |doc|
      next unless doc['content_metadata_image_iiif_info_ssm'].present?
      {
        'id': doc['id'],
        'full_title_tesim': doc['title_tesim'],
        'spotlight_upload_attribution_tesim': doc['creator_tesim'],
        'iiif_manifest_url_ssi': doc['content_metadata_image_iiif_info_ssm'],
        'exhibit_' + exhibit.slug + '_subject_tesim' => doc['subject_tesim'],
        'exhibit_' + exhibit.slug + '_archival-collection_tesim' => doc['archival_collection_tesim'],
        'exhibit_' + exhibit.slug + '_repository_tesim' => doc['repository_tesim'],
        'exhibit_' + exhibit.slug + '_item-location_tesim' => doc['location_repo_tesim'],
        'spotlight_upload_description_tesim': doc['description_tesim'],
        'spotlight_upload_date_tesim': doc['date_tesim'],
        'thumbnail_url_ssm': doc['content_metadata_image_iiif_info_ssm'][0].to_s.gsub('info.json', 'full/!400,400/0/native.jpg')
      }
    end
  end
end
