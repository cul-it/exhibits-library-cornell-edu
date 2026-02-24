# frozen_string_literal: true

RSpec.describe Cul::ApplicationUploader do
  subject(:application_uploader) { described_class.new }

  describe '#url' do
    subject(:url) { application_uploader.url }

    context 'when AWS file is present' do
      let(:aws_file) { instance_double('CarrierWave::Storage::AWSFile', public_url: 'https://example-bucket.s3.amazonaws.com/file.jpg') }
      before do
        allow(application_uploader).to receive(:file).and_return(aws_file)
      end

      it 'return the AWS public url' do
        expect(url).to eq('https://example-bucket.s3.amazonaws.com/file.jpg')
      end
    end

    context 'when AWS file is not present' do
      let(:file) { instance_double('CarrierWave::Storage::File') }
      before do
        allow(application_uploader).to receive(:file).and_return(file)
      end

      it 'return nil' do
        expect(url).to be_nil
      end
    end
  end
end
