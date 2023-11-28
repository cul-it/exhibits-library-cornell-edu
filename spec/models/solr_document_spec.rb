require 'rails_helper'

describe SolrDocument, type: :model do
  describe '#update_exhibit_resource' do
    let(:uploaded_solr_doc) do
      described_class.new(spotlight_resource_type_ssim: 'spotlight/resources/uploads')
    end
    let(:file) do
      Rack::Test::UploadedFile.new(File.expand_path(File.join('..', 'fixtures', 'grey.png'), __dir__))
    end

    before do
      allow(uploaded_solr_doc).to receive(:uploaded_resource) { uploaded_resource }
    end

    context 'resource with uploaded image' do
      let(:featured_image) { create(:featured_image) }
      let(:uploaded_resource) { create(:upload, upload: featured_image) }

      it 'updates the image' do
        old_image = uploaded_resource.upload.image
        uploaded_solr_doc.update_exhibit_resource({ 'url' => file })
        new_image = uploaded_resource.upload.image
        expect(old_image.identifier).not_to eq(new_image.identifier)
        expect(new_image.identifier).to eq('grey.png')
      end
    end

    context 'resource with no uploaded image' do
      let(:uploaded_resource) { create(:upload, upload: nil) }

      it 'adds a new image' do
        uploaded_solr_doc.update_exhibit_resource({ 'url' => file })
        expect(uploaded_resource.upload.image.identifier).to eq('grey.png')
      end
    end
  end
end
