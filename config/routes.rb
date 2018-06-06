Rails.application.routes.draw do
  resources :products, only: [:index, :create, :new] do
    resources :reviews, only: [:index]
  end

  root 'products#new'
end
