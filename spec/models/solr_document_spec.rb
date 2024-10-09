require 'rails_helper'

describe SolrDocument, type: :model do
  describe '#update_exhibit_resource' do
    let(:uploaded_solr_doc) { described_class.new(spotlight_resource_type_ssim: 'spotlight/resources/uploads') }
    let(:file_1) { Rack::Test::UploadedFile.new(File.expand_path('../fixtures/grey.png', __dir__)) }
    let(:file_2) { Rack::Test::UploadedFile.new(File.expand_path('../fixtures/red.png', __dir__)) }
    let(:image_1) { create(:featured_image) }
    let(:image_2) { create(:featured_image_alternate) }

    before do
      allow(uploaded_solr_doc).to receive(:uploaded_resource) { uploaded_resource }
    end

    context 'resource with 1 uploaded image' do
      let(:uploaded_resource) { create(:upload, uploads: [image_1]) }

      it 'updates the image' do
        old_image = uploaded_resource.uploads.first.image
        uploaded_solr_doc.update_exhibit_resource({ 'url' => [file_1] })
        expect(uploaded_resource.reload.uploads.count).to eq(1)
        new_image = uploaded_resource.uploads.first.image
        expect(old_image.identifier).not_to eq(new_image.identifier)
        expect(new_image.identifier).to eq('grey.png')
      end
    end

    context 'resource with multiple uploaded images' do
      let(:uploaded_resource) { create(:upload, uploads: [image_1, image_2]) }

      context 'resource with more uploads than new urls' do
        it 'updates existing uploads and deletes extra uploads' do
          expect(uploaded_resource.uploads.map { |u| u.image.identifier }).to eq(['white.png', 'grey.png'])
          uploaded_solr_doc.update_exhibit_resource({ 'url' => [file_2] })
          uploaded_resource.reload

          expect(Spotlight::FeaturedImage.where(id: [image_1.id, image_2.id],
                                                spotlight_resource_id: uploaded_resource.id).count).to eq(1)
          expect(uploaded_resource.uploads.map { |u| u.image.identifier }).to eq(['red.png'])
        end
      end

      context 'resource with fewer uploads than new urls' do
        let(:uploaded_resource) { create(:upload, uploads: [image_1]) }

        it 'updates existing uploads and adds new uploads' do
          expect(uploaded_resource.uploads.map { |u| u.image.identifier }).to eq(['white.png'])
          uploaded_solr_doc.update_exhibit_resource({ 'url' => [file_1, file_2] })
          uploaded_resource.reload

          expect(Spotlight::FeaturedImage.find_by(id: image_1.id,
                                                  spotlight_resource_id: uploaded_resource.id)).to be_present
          expect(uploaded_resource.uploads.map { |u| u.image.identifier }).to eq(['grey.png', 'red.png'])
        end
      end
    end

    context 'resource with no uploaded images' do
      let(:uploaded_resource) { create(:upload, uploads: []) }

      it 'adds a new image' do
        uploaded_solr_doc.update_exhibit_resource({ 'url' => [file_1] })
        expect(uploaded_resource.uploads.map { |u| u.image.identifier }).to eq(['grey.png'])
      end
    end
  end
end
