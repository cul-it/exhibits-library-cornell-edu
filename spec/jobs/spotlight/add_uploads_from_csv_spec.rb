require 'rails_helper'

# Tweaks add_uploads_from_csv_spec.rb from blacklight-spotlight gem since we're overriding the whole job
describe Spotlight::AddUploadsFromCsv do
  subject(:job) { described_class.new(data, exhibit, user, csv_file_name) }

  let(:exhibit) { create(:exhibit) }
  let(:user) { exhibit.users.first }
  let(:csv_file_name) { 'test.csv' }
  let(:data) do
    [
      { 'url' => 'x' },
      { 'url' => 'y' },
      { 'url' => '~' }
    ]
  end

  let(:resource_x) { instance_double(Spotlight::Resource) }
  let(:resource_y) { instance_double(Spotlight::Resource) }

  before do
    allow(Spotlight::IndexingCompleteMailer).to receive(:documents_indexed).and_return(double(deliver_now: true))
  end

  it 'sends the user an email when the job is finished processing and includes the csv file name' do
    expect(Spotlight::IndexingCompleteMailer).to receive(:documents_indexed).with(
      { csv_data: data, csv_file_name: csv_file_name },
      exhibit,
      user,
      indexed_count: anything,
      errors: anything
    ).and_return(double(deliver_now: true))
    job.perform_now
  end

  context 'with empty data' do
    let(:data) { [] }

    it 'sends the user an email after the indexing job is complete' do
      expect(Spotlight::IndexingCompleteMailer).to receive(:documents_indexed).and_return(double(deliver_now: true))
      job.perform_now
    end
  end

  it 'creates uploaded resources for each row of data' do
    upload = create(:upload)
    expect(Spotlight::Resources::Upload).to receive(:new).exactly(3).times.and_return(upload)

    expect(upload.uploads).to receive(:build).with(remote_image_url: 'x').and_call_original
    expect(upload.uploads).to receive(:build).with(remote_image_url: 'y').and_call_original
    expect(upload.uploads).not_to receive(:build).with(remote_image_url: '~')
    expect(upload).to receive(:save_and_index).at_least(:once)

    job.perform_now
  end

  context 'with errors' do
    it 'collects errors uploaded resources for each row of data' do
      allow(Spotlight::IndexingCompleteMailer).to receive(:documents_indexed).and_return(double(deliver_now: true))
      job.perform_now
      expect(Spotlight::IndexingCompleteMailer).to have_received(:documents_indexed).with(
        { csv_data: data, csv_file_name: csv_file_name },
        exhibit,
        user,
        indexed_count: 1,
        errors: {
          1 => array_including(match(Regexp.union(/relative URI: x/, /URI scheme '' not in whitelist:/))),
          2 => array_including(match(Regexp.union(/relative URI: x/, /URI scheme '' not in whitelist:/)))
        }
      )
    end
  end
end
