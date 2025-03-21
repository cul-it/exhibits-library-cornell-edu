# frozen_string_literal: true

RSpec.describe Spotlight::BulkUpdatesUploader do
  subject(:bulk_updates_uploader) { described_class.new(mounter, 'mounted_as') }

  let(:mounter) { Spotlight::BulkUpdate.new(id: '1') }

  describe '#store_dir' do
    let(:store_dir) { bulk_updates_uploader.store_dir }

    it 'includes filepath to tmp directory' do
      expect(store_dir).to eq Rails.root.join("tmp/uploads/spotlight/bulk_update/mounted_as/#{mounter.id}")
    end
  end
end
