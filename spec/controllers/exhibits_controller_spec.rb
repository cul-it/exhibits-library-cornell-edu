require 'rails_helper'

describe Spotlight::ExhibitsController, type: :controller do
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
end
