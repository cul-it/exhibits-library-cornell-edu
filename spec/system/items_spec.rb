require 'rails_helper'

describe 'Adding exhibit items', type: :system do
  let(:exhibit) { create(:exhibit) }
  let(:user) { exhibit.users.first }

  before do
    login_as(user)
  end

  describe 'adding items' do
    it 'creates new items with uploaded files', js: true do
      visit spotlight.exhibit_path(exhibit)
      click_link user.email
      click_link 'Exhibit dashboard'
      find('#sidebar').click_link 'Items'
      click_link 'Add items'
      click_link 'Upload item'

      # Add item #1
      page.attach_file('resources_upload[url][]', [File.expand_path('../fixtures/grey.png', __dir__)], make_visible: true)
      fill_in 'Title', with: 'A new item?!'
      fill_in 'Description', with: 'A new item description'
      fill_in 'Physical Location', with: 'A physical location'
      find('input[name="add-and-continue"]').click
      sleep 1

      # Add item #2
      page.attach_file('resources_upload[url][]', [File.expand_path('../fixtures/white.png', __dir__), File.expand_path('../fixtures/red.png', __dir__)], make_visible: true)
      fill_in 'Title', with: 'Item with multiple images'
      fill_in 'Description', with: 'This item has so many images, you would not believe.'
      fill_in 'Physical Location', with: 'Some other physical location'
      find('input[name="commit"]').click

      # Verify that the items were added
      expect(page).to have_text('Object uploaded successfully.')
      within '#documents' do
        expect(page).to have_link('A new item?!')
        expect(page).to have_link('Item with multiple images')
        # Can't just click link by text because another hidden link exists with matching alt text
        find('.index_title a', text: 'Item with multiple images').click
      end
      expect(page).to have_text('This item has so many images, you would not believe.')
      expect(page).to have_text('Some other physical location')
      expect(page).to have_text('1 of 2', normalize_ws: true)
    end
  end

  describe 'updating items' do
    let!(:item) { create(:upload, data: item_data, exhibit: exhibit) }
    let(:item_data) do
      {
        'full_title_tesim' => 'My item title',
        'spotlight_upload_description_tesim' => 'My item description',
        'spotlight_upload_attribution_tesim' => '',
        'spotlight_upload_date_tesim' => '',
        'spotlight_copyright_tesim' => '',
        'spotlight_physicallocation_tesim' => 'My item physical location'
      }
    end

    before do
      Spotlight::ReindexExhibitJob.perform_now(exhibit, user: user)
    end

    it 'updates existing items with new uploaded files', js: true do
      visit spotlight.exhibit_dashboard_path(exhibit)
      find('#sidebar').click_link 'Items'
      expect(page).to have_text('Curation Items', normalize_ws: true)
      find('#documents tbody tr:first-child').find_link('View').click
      expect(page).to have_text('Description: My item description', normalize_ws: true)
      expect(page).not_to have_text('1 of', normalize_ws: true)
      click_link 'Edit'
      sleep 2
      expect(page).to have_text('Valid file types:')
      page.attach_file('solr_document_uploaded_resource_url', [File.expand_path('../fixtures/white.png', __dir__), File.expand_path('../fixtures/red.png', __dir__)], make_visible: true)
      expect(page).to have_field('Title', with: 'My item title')
      expect(page).to have_field('Description', with: 'My item description')
      expect(page).to have_field('Physical Location', with: 'My item physical location')
      fill_in 'Description', with: 'A new item description'
      click_button 'Save changes'

      sleep 1
      expect(page).to have_text('Description: A new item description', normalize_ws: true)
      expect(page).to have_text('My item title')
      expect(page).to have_text('1 of 2', normalize_ws: true)
    end
  end
end
