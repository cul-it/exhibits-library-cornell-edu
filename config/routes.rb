Rails.application.routes.draw do
  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Riiif::Engine => '/images', as: 'riiif'

  root to: 'spotlight/exhibits#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount OkComputer::Engine, at: "/syscheck"

  devise_for :users

  mount Spotlight::Engine, at: '/' # as opposed to `at: 'spotlight'` which was generated
  mount Blacklight::Engine => '/'
  # root to: "catalog#index" # replaced by spotlight root path
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get '/:exhibit_id/itempages' => 'spotlight/itempages#item_pages'

  ### TODO: Portal access is temporarily removed.  See Issue #35.
  # resources :exhibits, only: [] do
  #   resources :portal_resources, only: [:create, :update] do
  #   end
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
