# frozen_string_literal: true
FactoryBot.define do
  factory :upload, class: 'Spotlight::Resources::Upload' do
    type { 'Spotlight::Resources::Upload' }
    data do
      {
        'full_title_tesim' => 'My item title',
        'spotlight_upload_description_tesim' => '',
        'spotlight_upload_attribution_tesim' => '',
        'spotlight_upload_date_tesim' => '',
        'spotlight_copyright_tesim' => '',
        'spotlight_physicallocation_tesim' => ''
      }
    end
    association :exhibit, factory: :exhibit
    uploads { @overrides[:uploads] || [create(:featured_image)] }

    factory :upload_with_multiple_images do
      uploads { [create(:featured_image), create(:featured_image_alternate)] }
    end
  end
end
