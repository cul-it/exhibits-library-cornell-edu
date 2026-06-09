require 'rails_helper'

RSpec.describe 'Sidekiq Dashboard Access', type: :system do
  let(:site_admin) { create(:user) }
  let(:random_user) { create(:user) }

  before do
    allow(site_admin).to receive(:site_admin?).and_return(true)
  end

  context 'as a site admin' do
    before do
      login_as(site_admin)
    end

    it 'allows access to the Sidekiq web GUI' do
      visit sidekiq_web_path

      expect(page).to have_current_path('/sidekiq')
      expect(page).to have_content('Sidekiq')
      expect(page).to have_content('Dashboard')
    end
  end

  context 'as an unauthorized user' do
    before do
      login_as(random_user)
    end

    it 'denies access to the Sidekiq web GUI and returns 404' do
      visit sidekiq_web_path
      expect(page).to have_current_path('/sidekiq')
      expect(page).to have_content('ActiveRecord::RecordNotFound')
    end
  end

  context 'while logged out' do
    it 'denies access to the Sidekiq web GUI and prompts login' do
      visit sidekiq_web_path
      expect(page).to have_current_path('/users/sign_in')
    end
  end
end
