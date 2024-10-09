# frozen_string_literal: true
FactoryBot.define do
  factory :exhibit, class: 'Spotlight::Exhibit' do
    title { 'My Exhibit' }

    after(:create) do |exhibit|
      user = create(:user)
      Spotlight::Role.create(user: user, resource: exhibit, role: 'admin')
    end
  end
end
