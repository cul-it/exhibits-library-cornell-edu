class DplaBuilder < Spotlight::SolrDocumentBuilder
    def to_solr
        content = JSON.parse(open(resource.url).read)
        content['docs'].map do |doc|
            {
                id: doc['id'],
                full_title_tesim: doc['sourceResource']['title'],
                Spotlight::Engine.config.thumbnail_field => doc['object'],
                creator_ssim: doc['sourceResource']['creator'],
                description_tesim: doc['sourceResource']['description'],
                subject_ssim: Array(doc['sourceResource']['subject']).map{|x| x['name']}
            }
        end
    end
end
