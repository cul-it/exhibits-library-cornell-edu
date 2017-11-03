class DplaBuilder < Spotlight::SolrDocumentBuilder
    def to_solr
        content = JSON.parse(open(resource.url).read)
        content['response']['docs'].map do |doc|
            {
                id: doc['id'],
                full_title_tesim: doc['title_tesim'],
                Spotlight::Engine.config.thumbnail_field => doc['media_URL_size_2_tesim'],
                creator_ssim: doc['creator_tesim'],
                description_tesim: doc['sourceResource']['description'],
                subject_ssim: Array(doc['subject_tesim']).map{|x| x['name']}
                iiif_manifest_url_ssi: doc['media_URL_tesim']
            }
        end
    end
end
