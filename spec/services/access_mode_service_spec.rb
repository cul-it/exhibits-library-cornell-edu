# frozen_string_literal: true

describe AccessModeService do
  describe '.limit_access_to_site_admins?' do
    context 'when access mode is set to site_admin_only' do
      before { stub_const('ENV', 'ACCESS_MODE' => 'site_admin_only') }
      it 'returns true' do
        expect(described_class.limit_access_to_site_admins?).to be true
      end
      context 'regardless of case' do
        before { stub_const('ENV', 'ACCESS_MODE' => 'sIte_adMin_onlY') }
        it 'returns true' do
          expect(described_class.limit_access_to_site_admins?).to be true
        end
      end
    end
    context 'when access mode is set to normal' do
      before { stub_const('ENV', 'ACCESS_MODE' => 'normal') }
      it 'returns false' do
        expect(described_class.limit_access_to_site_admins?).to be false
      end
    end
  end

  describe '.site_admins' do
    context 'when there are no site admins set' do
      before { stub_const('ENV', 'SITE_ADMINS' => nil) }
      it 'returns an array with the one site admin' do
        expect(described_class.site_admins).to eq []
      end
    end
    context 'when one site admin is set' do
      before { stub_const('ENV', 'SITE_ADMINS' => 'user1@example.com') }
      it 'returns an array with the one site admin' do
        expect(described_class.site_admins).to eq ['user1@example.com']
      end
    end
    context 'when one site admin is set' do
      before { stub_const('ENV', 'SITE_ADMINS' => 'user1@example.com;user2@example.com') }
      it 'returns an array with the one site admin' do
        expect(described_class.site_admins).to match_array ['user1@example.com', 'user2@example.com']
      end
    end
  end
end
