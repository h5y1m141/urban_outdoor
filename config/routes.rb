require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/admin/sidekiq'
  devise_for(:users,
             path: 'admin',
             path_names: {sign_in: 'home'},
             controllers: {sessions: 'users/sessions'}
             )
  resources :items
  resources :users
  resources :stores
  resources :articles, only: [:index, :show]
  controller :static_pages do
    get :about
  end
  namespace :admin do
    resources :items, only: [:index, :edit, :update, :destroy]
    resources :articles do
      collection do
        post :load_elements
      end
    end
    
  end
  root to: 'static_pages#index'
  get '/articles/preview/:preview_key', to: 'articles#preview'
end
