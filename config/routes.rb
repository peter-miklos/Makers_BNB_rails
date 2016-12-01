Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'spaces#index'

  resources :spaces do
    resources :requests
    resources :bookings
  end

  resources :my_requests
end
