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

  describe '#themes_selector' do
    # assuming that the first theme in the list will be a default theme
    # and the last theme will be a custom theme
    let(:non_custom_theme) { Spotlight::Engine.config.exhibit_themes.first }
    let(:custom_theme) { Spotlight::Engine.config.exhibit_themes.last }

    # define test exhibits
    let(:ex_non_custom) { Spotlight::Exhibit.new(slug: non_custom_theme) }
    let(:ex_non_custom_wip) { Spotlight::Exhibit.new(slug: non_custom_theme + '-WIP') }
    let(:ex_custom) { Spotlight::Exhibit.new(slug: custom_theme) }
    let(:ex_custom_wip) { Spotlight::Exhibit.new(slug: custom_theme + '-WIP') }
    let(:ex_custom_similar) { Spotlight::Exhibit.new(slug: custom_theme + '-WIP-butnotreally') }

    # helper method to count the number of themes for a given test exhibit
    def theme_count(exhibit)
      exhibit.themes_selector.call(exhibit).count
    end

    it 'returns the same number of themes for non-custom and WIP non-custom exhibit' do
      expect(theme_count(ex_non_custom)).to eq(theme_count(ex_non_custom_wip))
    end

    it 'returns 1 more theme for custom exhibit than for non-custom exhibit' do
      expect(theme_count(ex_custom) - 1).to eq(theme_count(ex_non_custom))
    end

    it 'returns the same number of themes for custom exhibit and WIP custom exhibit' do
      expect(theme_count(ex_custom)).to eq(theme_count(ex_custom_wip))
    end

    it 'returns 1 more theme choices for a custom exhibit than one with a similar WIP name' do
      expect(theme_count(ex_custom) - 1).to eq(theme_count(ex_custom_similar))
    end
  end
end
