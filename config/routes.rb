Rails.application.routes.draw do
  root to: 'static_pages#index'
  resources :items
  resources :users

  controller :static_pages do
    get :about
  end
end
