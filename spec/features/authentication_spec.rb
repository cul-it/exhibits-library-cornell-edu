require 'rails_helper'

RSpec.feature 'Unauthorized Access', type: :feature do
  scenario 'Go to home page without logging in first' do
    visit '/users/sign_in'

    expect(page).to have_text('Forgot your password?')
  end
end

RSpec.feature 'Authorized Access', type: :feature do
  let(:user) { create(:user) }

  scenario 'Log in and reach home page' do
    visit '/users/sign_in'

    fill_in('user_email', with: user.email)
    fill_in('user_password', with: user.password)
    click_button('Log in')

    expect(page).to have_text('Signed in successfully.')
  end

  scenario 'Log in and reset password', js: true do
    login_as(user)
    visit '/'

    click_link(user.email)
    click_link('Change Password')

    expect(page).to have_text('Edit User')

    fill_in('user_email', with: user.email)
    fill_in('user_password', with: '123456!')
    fill_in('user_password_confirmation', with: '123456!')
    fill_in('user_current_password', with: user.password)
    click_button('Update')

    # TODO: Flash message no longer exists in Spotlight v5 - investigate, report bug, or update test
    # expect(page).to have_text('Your account has been updated successfully.')
  end
end
