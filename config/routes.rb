Rails.application.routes.draw do
  resources :stores

  root to: 'static_pages#index'
  resources :items
  resources :users
  namespace :admin do
    resources :items, only: [:index, :edit, :update, :destroy]
    resources :articles
  end
  controller :static_pages do
    get :about
  end
end
