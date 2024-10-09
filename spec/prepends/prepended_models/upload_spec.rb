require 'rails_helper'

# Tests overrides in PrependedModels::Upload
describe Spotlight::Resources::Upload, type: :model do
  describe '#to_solr' do
    let(:upload_resource) { create(:upload_with_multiple_images) }

    it 'returns a hash that includes tilesources' do
      solr_attrs = upload_resource.to_solr
      expect(solr_attrs.keys).to match_array([:spotlight_full_image_width_ssm,
                                              :spotlight_full_image_height_ssm,
                                              :thumbnail_url_ssm,
                                              :iiif_manifest_url_ssi,
                                              :content_metadata_image_iiif_info_ssm])
      expect(solr_attrs[:spotlight_full_image_width_ssm]).to eq([800, 800])
      expect(solr_attrs[:spotlight_full_image_height_ssm]).to eq([800, 800])
      expect(solr_attrs[:thumbnail_url_ssm]).to include('!400,400')
      expect(solr_attrs[:iiif_manifest_url_ssi]).to eq("/#{upload_resource.exhibit.slug}/catalog/#{upload_resource.compound_id}/manifest")
      tilesource_paths = solr_attrs[:content_metadata_image_iiif_info_ssm]
      expect(tilesource_paths.map { |tilesource| tilesource.split('/')[-1] }).to eq(['info.json', 'info.json'])
    end
  end
end
