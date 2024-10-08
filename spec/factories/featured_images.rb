# frozen_string_literal: true
FactoryBot.define do
  factory :featured_image, class: 'Spotlight::FeaturedImage' do
    image { Rack::Test::UploadedFile.new(File.expand_path('../fixtures/white.png', __dir__)) }
  end

  factory :featured_image_alternate, class: 'Spotlight::FeaturedImage' do
    image { Rack::Test::UploadedFile.new(File.expand_path('../fixtures/grey.png', __dir__)) }
  end
end
