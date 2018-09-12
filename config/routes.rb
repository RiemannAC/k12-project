Rails.application.routes.draw do

  # Singular Resoruce
  root "calendar#show"
  resource :calendar, only: [:show], controller: :calendar

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users do
    member do
      get :week_sche
      get :month_sche
    end
  end

end
