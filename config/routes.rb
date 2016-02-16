Rails.application.routes.draw do
  devise_for(:users,
             path: 'admin',
             path_names: {sign_in: 'home'},
             controllers: {sessions: 'users/sessions'}
             )
  resources :items
  resources :users
  resources :stores
  controller :static_pages do
    get :about
  end
  namespace :admin do
    resources :items, only: [:index, :edit, :update, :destroy]
    resources :articles
  end
  root to: 'static_pages#index'
end
