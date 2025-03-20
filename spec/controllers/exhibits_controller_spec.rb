require 'rails_helper'

describe Spotlight::ExhibitsController, type: :controller do
  routes { Spotlight::Engine.routes }

  describe 'GET index' do
    context 'multiple published exhibits' do
      it 'orders published exhibits by asc weight first, then desc published_dat dates' do
        # Set up exhibits
        published_exhibit1 = create(:exhibit, published: true).tap { |e| e.update(weight: 10, published_at: nil) }
        published_exhibit2 = create(:exhibit, published: true).tap { |e| e.update(weight: 0) }
        create(:exhibit, published: false, weight: 0)
        published_exhibit3 = create(:exhibit, published: true).tap { |e| e.update(weight: 20) }
        published_exhibit4 = create(:exhibit, published: true).tap { |e| e.update(weight: 10, published_at: 1.day.ago) }
        published_exhibit5 = create(:exhibit, published: true).tap { |e| e.update(weight: 10) }

        # Check published_exhibits order on index
        get :index
        expect(response).to render_template('spotlight/home')
        expect(assigns(:published_exhibits)).to eq([published_exhibit2, published_exhibit5, published_exhibit4, published_exhibit1, published_exhibit3])
      end
    end

    context 'one exhibit' do
      it 'redirects to the exhibit' do
        exhibit = create(:exhibit, published: true)
        get :index
        expect(response).to redirect_to(exhibit)
      end
    end
  end
  
  describe 'PATCH update' do
    let(:exhibit) { create(:exhibit, title: 'Test Exhibit', slug: 'test', published: true, weight: 10, published_at: nil) }
    let(:user) { create(:user) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      sign_in user
      # Stub the authorization check
      allow(controller).to receive(:authorize!).and_return(true)
    end

    context 'when an unpublished exhibit is published for the first time' do
      before { exhibit.update(published: false, published_at: nil) }
      it 'sends a notification' do
        expect(controller).to receive(:send_publish_notification).with(exhibit)
        post :update, params: { id: exhibit.id, exhibit: { published: true } }
      end
    end

    context 'when an unpublished exhibit is published again' do
      before { exhibit.update(published: false, published_at: 3.day.ago) }
      it 'sends a notification' do
        expect(controller).to receive(:send_publish_notification).with(exhibit)
        post :update, params: { id: exhibit.id, exhibit: { published: true } }
      end
    end

    context 'when an unpublished exhibit is saved but is not published' do
      before { exhibit.update(published: false, published_at: nil) }
      it 'does not send a notification' do
        expect(controller).not_to receive(:send_publish_notification).with(exhibit)
        post :update, params: { id: exhibit.id, exhibit: { published: false } }
      end
    end

    context 'when a published exhibit is unpublished' do
      before { exhibit.update(published: true, published_at: Time.current) }
      it 'does not send a notification' do
        expect(controller).not_to receive(:send_publish_notification).with(exhibit)
        patch :update, params: { id: exhibit.id, exhibit: { published: false } }
      end
    end

    context 'when a published exhibit is saved and remains published' do
      before { exhibit.update(published: true, published_at: Time.current) }
      it 'does not send a notification' do
        expect(controller).not_to receive(:send_publish_notification).with(exhibit)
        patch :update, params: { id: exhibit.id, exhibit: { published: true } }
      end
    end
  end
end
