Rails.application.routes.draw do

  # Singular Resoruce
  root "calendar#show"
  resource :calendar, only: [:show], controller: :calendar

  resources :plans do
    resources :teachingfiles
  end

  resources :materials do
    resources :teachingfiles
  end

  resources :classrooms do
    resources :teachingschedules
  end

  resources :topics 

  

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users do
    member do
      get :week_sche
      get :month_sche
    end
  end

end
