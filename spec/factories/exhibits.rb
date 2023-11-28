# frozen_string_literal: true
FactoryBot.define do
  factory :exhibit, class: 'Spotlight::Exhibit' do
    title { 'My Exhibit' }
    slug { 'my-exhibit' }
  end
end
