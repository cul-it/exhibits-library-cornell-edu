require 'rails_helper'

describe 'Adding exhibit users', type: :system do
  let(:exhibit) { create(:exhibit) }

  describe 'adding users' do
    before do
      login_as(exhibit.users.first)
    end

    it 'admins can add a new user', js: true do
      visit spotlight.exhibit_roles_path(exhibit)
      click_on 'Add a new user'
      fill_in 'User key', with: 'newuser@cornell.edu'
      click_button 'Save changes'
      expect(page).to have_content 'User has been updated.'
    end

    it 'admins can add a feedback recipient' do
      visit spotlight.edit_exhibit_path(exhibit)
      fill_in 'exhibit_contact_email_0', with: 'feedbackrecipient@example.com'
      click_button 'Save changes'
      expect(page).to have_content('The exhibit was successfully updated.')
    end
  end

  describe 'accepting invites' do
    context 'exhibit roles' do
      it 'invited users can accept their role invitation', js: true do
        invited_role = exhibit.roles.create(role: 'curator', user_key: 'newcurator@cornell.edu')
        visit accept_user_invitation_path(invitation_token: invited_role.user.raw_invitation_token)
        click_button('Log in with your NetID')
        expect(page).to have_content 'You are logged in as test123.'
      end
    end
    it 'invited feedback recipients can confirm their emails' do
      contact_email = create(:contact_email, exhibit:, confirmation_token: "TOKEN", confirmation_sent_at: Time.now.utc)
      visit spotlight.contact_email_confirmation_path(confirmation_token: contact_email.confirmation_token)
      # Redirected to sign_in page
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      expect(page).to have_content 'Log in'
    end
  end
end
