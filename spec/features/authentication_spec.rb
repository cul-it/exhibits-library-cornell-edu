require 'rails_helper'

RSpec.feature 'Unauthorized Access', type: :feature do
  scenario 'Go to home page without logging in first' do
    visit '/users/sign_in'

    expect(page).to have_text('Log in with your NetID')
  end
end

RSpec.feature 'Authorized Access', type: :feature do
  let(:user) { create(:user) }

  scenario 'Log in and reach home page' do
    visit '/users/sign_in'

    click_button('Log in with your NetID')

    expect(page).to have_text('You are logged in as test123.')
  end
end
