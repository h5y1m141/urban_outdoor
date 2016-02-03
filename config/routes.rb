Rails.application.routes.draw do
  resources :stores

  root to: 'static_pages#index'
  resources :items
  resources :users

  controller :static_pages do
    get :about
  end
end
