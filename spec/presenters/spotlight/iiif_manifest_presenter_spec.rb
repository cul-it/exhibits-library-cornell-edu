require 'rails_helper'

# Reuses some specs from iiif_manifest_presenter_spec in blacklight-spotlight gem to test the overriden methods
describe Spotlight::IiifManifestPresenter do
  require 'iiif_manifest'

  let(:resource) { SolrDocument.new(id: '1-1', spotlight_resource_type_ssim: 'spotlight/resources/uploads') }
  let(:uploaded_resource) { create(:upload) }
  let(:controller) { double(Spotlight::CatalogController) }
  let(:subject) { described_class.new(resource, controller) }
  let(:profile_url) { 'http://iiif.io/api/image/2/level2.json' }
  let(:helpers) { double(document_presenter: presenter) }
  let(:presenter) { instance_double(Blacklight::ShowPresenter, heading: title_field_value) }
  let(:iiif_url) { 'https://iiif.test/images/1-1' }
  let(:endpoint) { IIIFManifest::IIIFEndpoint.new(iiif_url, profile: profile_url) }
  let(:manifest_url) { 'https://iiif.test/spotlight/test/catalog/1-1/manifest' }
  let(:spotlight_route_helper) { double }
  let(:blacklight_config) { double(Spotlight::BlacklightConfiguration) }
  let(:title_field_value) { 'title' }
  let(:description_field_value) { 'description' }

  before do
    allow(resource).to receive(:uploaded_resource).and_return(uploaded_resource)
  end

  before do
    allow(spotlight_route_helper).to receive(:manifest_exhibit_solr_document_url).with(uploaded_resource.exhibit, resource).and_return(manifest_url)
    allow(controller).to receive(:spotlight).and_return(spotlight_route_helper)
    allow(resource).to receive(:first).with(Spotlight::Engine.config.upload_description_field).and_return(description_field_value)
    allow(controller).to receive(:view_context).and_return(helpers)
  end

  describe '#file_set_presenters' do
    it "returns a list containing featured image data for resource on which it's called" do
      file_presenters = subject.file_set_presenters
      expect(file_presenters.count).to eq(1)
    end
  end

  describe '#work_presenters' do
    it "returns an empty list, because we don't yet support interstitial nodes in the document manifest" do
      expect(subject.work_presenters).to eq([])
    end
  end

  describe '#manifest_url' do
    it 'relays the value from the spotlight route url helper' do
      expect(subject.manifest_url).to eq(manifest_url)
    end
  end

  describe '#description' do
    it 'gets the description from the resource using the configured upload_description_field' do
      expect(subject.description).to eq(description_field_value)
    end
  end

  describe '#iiif_manifest' do
    it 'builds a IIIFManifest object based on the presenter object info' do
      result = subject.iiif_manifest
      expect(result).to be_an_instance_of(IIIFManifest::ManifestBuilder)
      expect(result.work).to be(subject)
    end
  end

  describe '#iiif_manifest_json' do
    it 'returns json for the manifest generated from the presenter object info' do
      riiif_route_helper = double(info_url: 'https://iiif.test/path/info.json')
      allow(controller).to receive(:riiif).and_return(riiif_route_helper)
      expect(subject.iiif_manifest_json).to eq(subject.iiif_manifest.to_h.to_json)
    end
  end
end
