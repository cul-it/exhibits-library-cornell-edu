# frozen_string_literal: true

RSpec.describe CarrierWave::Uploader::Base do
  subject(:uploader) { described_class.new }

  let(:path) { 'file.jpg' }
  let(:file) { double(:file, public_url: 'https://example-bucket.s3.amazonaws.com/file.jpg') }
  let(:bucket) { double(:bucket, object: file) }
  let(:connection) { double(:connection, bucket: bucket) }
  let(:aws_file) { CarrierWave::Storage::AWSFile.new(uploader, connection, path) }

  before do
    allow(uploader).to receive(:file).and_return(aws_file)
  end

  describe '#url' do
    context 'when aws_acl is set to public-read' do
      before do
        allow(uploader).to receive(:aws_acl).and_return('public-read')
      end

      it 'uploader returns the public url from the aws file' do
        expect(uploader.url).to eq('https://example-bucket.s3.amazonaws.com/file.jpg')
      end
    end

    context 'when aws_acl is not set to public-read' do
      before do
        allow(uploader).to receive(:aws_acl).and_return('private')
        allow(aws_file).to receive(:authenticated_url).and_return('https://example-bucket.s3.amazonaws.com/file.jpg?X-Amz-Signature=123')
      end

      it 'uploader does not return the public url from the aws file' do
        expect(uploader.url).to eq('https://example-bucket.s3.amazonaws.com/file.jpg?X-Amz-Signature=123')
      end
    end
  end
end
