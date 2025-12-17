require 'rails_helper'

describe Spotlight::ExhibitsController, type: :controller do
  describe 'GET index' do
    context 'multiple published exhibits' do
      before do
        # Set up exhibits
        @published_exhibit1 = create(:exhibit, published: true).tap { |e| e.update(weight: 10, published_at: nil) }
        @published_exhibit2 = create(:exhibit, published: true).tap { |e| e.update(weight: 0) }
        @unpublished_exhibit = create(:exhibit, published: false, weight: 0)
        @published_exhibit3 = create(:exhibit, published: true).tap { |e| e.update(weight: 20) }
        @published_exhibit4 = create(:exhibit, published: true).tap { |e| e.update(weight: 10, published_at: 1.day.ago) }
        @published_exhibit5 = create(:exhibit, published: true).tap { |e| e.update(weight: 10) }
        @published_taggedexhibit = create(:exhibit, published: true).tap { |e| e.update(weight: 30, published_at: 2.days.ago, tag_list: ['test']) }
      end

      it 'orders published exhibits by asc weight first, then desc published_dat dates' do
        # Check published_exhibits order on index
        get :index, format: :html
        expect(response).to render_template('spotlight/home')
        expect(assigns(:published_exhibits)).to eq([@published_exhibit2, @published_exhibit5, @published_exhibit4, @published_exhibit1, @published_exhibit3, @published_taggedexhibit])
      end

      it 'orders correctly and applies the limit parameter for RSS' do
        get :index, params: { limit: 3 }, format: :rss
        expect(assigns(:rss_feed)).to eq([@published_exhibit2, @published_exhibit5, @published_exhibit4])
      end

      it 'filters using the tag parameter for RSS' do
        get :index, params: { tag: 'test' }, format: :rss
        expect(assigns(:rss_feed)).to eq([@published_taggedexhibit])
      end
    end

    context 'one exhibit' do
      it 'redirects to the exhibit' do
        exhibit = create(:exhibit, published: true)
        get :index, format: :html
        expect(response).to redirect_to(exhibit)
      end

      it 'renders the RSS feed for one exhibit' do
        # make sure it does not redirect when only 1 exhibit
        exhibit = create(:exhibit, published: true)
        get :index, format: :rss
        expect(assigns(:rss_feed)).to eq([exhibit])
      end
    end
  end
end
