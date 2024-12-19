require 'rails_helper'

describe 'Editing spotlight pages', type: :system do
  let(:exhibit) { create(:exhibit) }
  let(:user) { exhibit.users.first }
  let!(:item) { create(:upload_with_multiple_images, exhibit: exhibit) }

  before do
    Spotlight::ReindexExhibitJob.perform_now(exhibit, user: user)
  end

  it 'embeds an item with multiple uploads using Item Embed widget', js: true do
    login_as(user)
    visit spotlight.exhibit_path(exhibit)
    click_link 'Edit'

    first('.st-block-replacer').click
    click_button('Item Embed')
    fill_in_solr_document_block_typeahead_field(with: item.compound_id)
    expect(page).to have_css('[data-panel-image-pagination]', text: /Image 1 of 2/, visible: true)

    # Open the multi-image selector and choose the last one
    click_link('Change')
    find('.thumbs-list li:last-child').click
    expect(page).to have_css('[data-panel-image-pagination]', text: /Image 2 of 2/, visible: true)

    click_button 'Save changes'
    expect(page).to have_text('The home page was successfully updated.')
    expect(page.find("*[data-id='#{item.compound_id}']")).to have_text('2 of 2', normalize_ws: true)
  end
end
