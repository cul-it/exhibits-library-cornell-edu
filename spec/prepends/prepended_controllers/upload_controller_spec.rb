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
        'spotlight_copyright_tesim' => '',
        'spotlight_physicallocation_tesim' => ''
      }
    end
    let(:exhibit) { create(:exhibit) }
    let(:user) { exhibit.users.first }

    context 'when not logged in' do
      it 'is not allowed' do
        post :create, params: { exhibit_id: exhibit }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in as a curator' do
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

      # Copies tests from spec/controllers/spotlight/resources/upload_controller_spec.rb in spotlight gem
      #   since #create is overridden in PrependedControllers
      it 'redirects to the item admin page' do
        post :create, params: { exhibit_id: exhibit, resources_upload: { url: [image_1], data: item_data } }
        expect(flash[:notice]).to eq('Object uploaded successfully.')
        expect(response).to redirect_to admin_exhibit_catalog_path(exhibit, sort: :timestamp)
      end

      it 'redirects to the upload form when the add-and-continue parameter is present' do
        post :create, params: { exhibit_id: exhibit, 'add-and-continue' => 'true', resources_upload: { url: [image_1], data: item_data } }
        expect(flash[:notice]).to eq('Object uploaded successfully.')
        expect(response).to redirect_to new_exhibit_resource_path(exhibit, tab: 'upload')
      end

      context 'invalid resource' do
        let(:too_large_image) { Rack::Test::UploadedFile.new(File.expand_path('../../fixtures/white_large.png', __dir__)) }
        let(:invalid_file_type) { Rack::Test::UploadedFile.new(File.expand_path('../../fixtures/invalid.txt', __dir__)) }

        it 'displays error messages when image is too large' do
          post :create, params: { exhibit_id: exhibit, resources_upload: { url: [too_large_image], data: item_data } }
          expect(flash[:error]).to eq('Your item could not be added. File size should be less than 10 MB.')
          expect(response).to redirect_to admin_exhibit_catalog_path(exhibit, sort: :timestamp)
        end

        it 'displays multiple errors messages, when multiple invalid files' do
          post :create, params: { exhibit_id: exhibit, resources_upload: { url: [too_large_image, invalid_file_type], data: item_data } }
          expect(flash[:error]).to include('Your item could not be added.')
          expect(flash[:error]).to include('File size should be less than 10 MB.')
          expect(flash[:error]).to include('You are not allowed to upload "txt" files, allowed types:')
        end
      end
    end
  end
end
