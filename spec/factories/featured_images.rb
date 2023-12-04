# frozen_string_literal: true
FactoryBot.define do
  factory :featured_image, class: 'Spotlight::FeaturedImage' do
    image { Rack::Test::UploadedFile.new(File.expand_path(File.join('..', 'fixtures', 'white.png'), __dir__)) }
  end
end
