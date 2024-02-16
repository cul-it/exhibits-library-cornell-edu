require 'rails_helper'

describe Spotlight::Exhibit, type: :model do
  describe 'callbacks' do
    describe '#set_published' do
      context 'publishing an exhibit' do
        let(:exhibit) { create(:exhibit, published: false, published_at: nil) }

        it 'sets published_at date and resets weight' do
          expect(exhibit.weight).to eq(50)

          # Publish exhibit
          new_published_at = Time.zone.now
          Timecop.freeze(new_published_at) do
            exhibit.published = true
            exhibit.save!
          end
          expect(exhibit.published_at).to eq(new_published_at)
          expect(exhibit.weight).to eq(0)
        end
      end

      context 'publishing an exhibit that has previously been published' do
        let(:exhibit) { create(:exhibit, published: false, published_at: Time.zone.now - 1.day, weight: 10) }

        it 'resets published_at only, not weight' do
          # Publish exhibit
          new_published_at = Time.zone.now
          Timecop.freeze(new_published_at) do
            exhibit.published = true
            exhibit.save!
          end
          expect(exhibit.published_at).to eq(new_published_at)
          expect(exhibit.weight).to eq(10)
        end
      end

      context 'saving already published exhibit' do
        let!(:exhibit) { create(:exhibit, published: true) }
        let(:published_at) { exhibit.published_at }

        it 'does not reset published_at or weight' do
          # Save exhibit
          exhibit.weight = 10
          exhibit.save!
          expect(exhibit.published_at).to eq(published_at)
          expect(exhibit.weight).to eq(10)
        end
      end
    end
  end
end
