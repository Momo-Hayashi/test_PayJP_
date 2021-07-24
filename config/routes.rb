Rails.application.routes.draw do
  resources :cards, only: [:new, :create]
  devise_for :users
  root 'items#index'
  resources :items do
    get :purchase
    get :pay
    patch :pay
  end
end
