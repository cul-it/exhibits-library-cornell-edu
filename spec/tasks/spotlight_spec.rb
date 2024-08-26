require 'rails_helper'

RSpec.describe 'spotlight:paper_trail:clear' do
  let(:rake) { Rake::Application.new }
  let!(:exhibit_91_days_old) { Timecop.freeze(91.days.ago) { create(:exhibit) } }
  let!(:exhibit_new) { create(:exhibit) }
  let!(:exhibit_366_days_old) { Timecop.freeze(366.days.ago) { create(:exhibit) } }

  before do
    Rake.application = rake
    Rails.application.load_tasks
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_new.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_91_days_old.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_366_days_old.id).count).to eq(1)
  end

  it 'deletes papertrail versions older than the specified days' do
    rake.invoke_task('spotlight:paper_trail:clear[90]')
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_new.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_91_days_old.id).count).to eq(0)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_366_days_old.id).count).to eq(0)
  end

  it 'deletes papertrail versions older than 365 days, if no days specified' do
    rake.invoke_task('spotlight:paper_trail:clear')
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_new.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_91_days_old.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_366_days_old.id).count).to eq(0)
  end

  it 'does not delete papertrail versions, if unexpected arguments given' do
    expect { rake.invoke_task('spotlight:paper_trail:clear[unexpected_argument]') }.to raise_error(ArgumentError)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_new.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_91_days_old.id).count).to eq(1)
    expect(PaperTrail::Version.where(item_type: 'Spotlight::Exhibit', event: 'create', item_id: exhibit_366_days_old.id).count).to eq(1)
  end
end
