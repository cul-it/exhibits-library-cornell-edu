require 'rails_helper'

describe ApplicationHelper do
  let(:current_user) { double('User') }
  let(:current_exhibit) { double('Exhibit') }
  let(:current_ability) { double('Ability') }
  let(:languages_double) { double('languages') }

  before do
    allow(current_exhibit).to receive(:languages).and_return(languages_double)
  end

  describe '#show_user_util_links?' do
    context 'when the visitor is an exhibits user' do
      it 'shows user options' do
        result = helper.show_user_util_links?(current_user, nil, nil)
        expect(result).to be true
      end

      it 'and is a feedback receipient it shows the feedback form' do
        allow(helper).to receive(:show_contact_form?).and_return(true)
        result = helper.show_user_util_links?(nil, current_exhibit, current_ability)
        expect(result).to be true
      end
    end

    context 'when the visitor is not an exhibits user' do
      it 'is not a feedback receipient, but has multiple language support it will show language options' do
        allow(helper).to receive(:show_contact_form?).and_return(false)
        allow(languages_double).to receive(:accessible_by).with(current_ability).and_return([:id])
        result = helper.show_user_util_links?(nil, current_exhibit, current_ability)
        expect(result).to be true
      end

      it 'not a feedback receipient and does not have multiple language support, does not show these options' do
        allow(helper).to receive(:show_contact_form?).and_return(false)
        allow(languages_double).to receive(:accessible_by).with(current_ability).and_return([])
        result = helper.show_user_util_links?(nil, current_exhibit, current_ability)
        expect(result).to be false
      end
    end
  end
end