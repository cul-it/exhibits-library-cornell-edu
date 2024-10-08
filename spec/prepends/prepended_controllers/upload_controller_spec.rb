require 'rails_helper'

# Tests overrides in PrependedControllers::UploadController
describe Spotlight::Resources::UploadController, type: :controller do
  routes { Spotlight::Engine.routes }

  describe 'POST create' do
    let(:image_1) { Rack::Test::UploadedFile.new(File.expand_path('../../fixtures/grey.png', __dir__)) }
    let(:image_2) { Rack::Test::UploadedFile.new(File.expand_path('../../fixtures/red.png', __dir__)) }
    let(:item_data) do
      {
        'full_title_tesim' => 'A cool item title',
        'spotlight_upload_description_tesim' => 'A nice description',
        'spotlight_upload_attribution_tesim' => '',
        'spotlight_upload_date_tesim' => '',
        'spotlight_copyright_tesim' => ''
      }
    end
    let(:exhibit) { create(:exhibit) }
    let(:user) { exhibit.users.first }

    before { sign_in user }

    it 'creates a new upload item with multiple featured images' do
      expect(exhibit.resources.count).to eq(0)
      post :create, params: {
        exhibit_id: exhibit,
        resources_upload: {
          url: [image_1, image_2],
          data: item_data
        },
        controller: 'spotlight/resources/upload',
        action: 'create'
      }
      expect(exhibit.resources.count).to eq(1)
      new_item = exhibit.resources.first
      expect(new_item.uploads.count).to eq(2)
    end
  end
end
