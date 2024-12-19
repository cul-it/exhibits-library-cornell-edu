require 'rails_helper'

describe Spotlight::FeaturedImageUploader do
  let(:mounter) { Spotlight::FeaturedImage.new }
  let(:featured_image_uploader) { described_class.new(mounter, 'mounted_as') }

  describe '#size_range' do
    it 'does not error when file is less than 10 megabytes' do
      test_file = File.open(File.expand_path('../../fixtures/grey.png', __dir__))
      expect { featured_image_uploader.cache!(test_file) }.not_to raise_error
    end

    it 'raises an error when file is more than 10 megabytes' do
      test_file = File.open(File.expand_path('../../fixtures/white_large.png', __dir__))
      expect { featured_image_uploader.cache!(test_file) }.to raise_error(CarrierWave::IntegrityError, 'File size should be less than 10 MB.')
    end
  end
end
