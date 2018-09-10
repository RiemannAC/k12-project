Rails.application.routes.draw do

  # Singular Resoruce
  root "calendar#show"
  resource :calendar, only: [:show], controller: :calendar

  resources :plans

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
