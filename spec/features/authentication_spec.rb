require 'rails_helper'

RSpec.feature "Unauthorized Access", type: :feature do
  scenario "Go to home page without logging in first" do
    visit "/users/sign_in"

    expect(page).to have_text("Forgot your password?")
  end
end

RSpec.feature "Authorized Access", type: :feature do
  scenario "Log in and reach home page" do
    user = FactoryBot.create(:user)

    visit "/users/sign_in"

    fill_in('user_email', with: user.email)
    fill_in('user_password', with: user.password)
    click_button('Log in')

    expect(page).to have_text('Signed in successfully.')
  end
end
