require 'rails_helper'

# Reuses some specs from iiif_manifest_presenter_spec in blacklight-spotlight gem to test the overriden methods
describe Spotlight::IiifFileSetPresenter do
  require 'iiif_manifest'

  let(:uploaded_resource) { create(:upload) }
  let(:upload) { uploaded_resource.uploads.first }
  let(:subject) { described_class.new(upload, img_width, img_height, controller, title_field_value) }
  let(:controller) { double(Spotlight::CatalogController) }
  let(:iiif_url) { 'https://iiif.test/images/1-1' }
  let(:profile_url) { 'http://iiif.io/api/image/2/level2.json' }
  let(:endpoint) { IIIFManifest::IIIFEndpoint.new(iiif_url, profile: profile_url) }
  let(:title_field_value) { 'title' }
  let(:img_width) { 11 }
  let(:img_height) { 10 }

  before do
    allow(subject).to receive(:endpoint).and_return(endpoint)
  end

  describe 'public methods' do
    describe '#display_image' do
      it 'returns a properly configured instance of IIIFManifest::DisplayImage' do
        # can't do:
        #   expect(subject.display_image).to eq(IIIFManifest::DisplayImage.new(upload.id, width: 11, height: 10, format: 'image/jpeg', iiif_endpoint: endpoint))
        # because IIIFManifest::DisplayImage doesn't implement #==
        result = subject.display_image
        expect(result.url).to eq upload.id
        expect(result.width).to eq img_width
        expect(result.height).to eq img_height
        expect(result.format).to eq 'image/jpeg'
        expect(result.iiif_endpoint).to eq endpoint
      end
    end

    describe '#to_s' do
      it "uses the resource's title field value as the presenter's string representation" do
        expect(subject.to_s).to eq(title_field_value)
      end
    end
  end

  describe 'private methods' do
    describe '#endpoint' do
      it 'returns a properly configured instance of IIIFManifest::IIIFEndpoint' do
        iiif_url = 'https://iiif.test/images/1-1'
        allow(subject).to receive(:iiif_url).and_return(iiif_url)

        result = subject.send(:endpoint)
        expect(result.url).to eq(iiif_url)
        expect(result.profile).to eq(profile_url)
      end
    end

    describe '#iiif_url' do
      it 'returns the info_url from the Riiif engine routes, minus the trailing .json' do
        allow(Spotlight::RiiifService).to receive(:info_url).and_return('https://iiif.test/path/info.json')

        expect(subject.send(:iiif_url)).to eq('https://iiif.test/path')
      end
    end
  end
end
