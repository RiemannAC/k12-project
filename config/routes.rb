Rails.application.routes.draw do

  # Singular Resoruce
  root "calendar#show" # 原 lib/calendar.rb 的 calendar struct 與simple_calendar 模組同名，現已更名為，calendar_hand.rb
  resource :calendar, only: [:show], controller: :calendar

  resources :plans do
    resources :teachingfiles
  end

  resources :materials do
    resources :teachingfiles
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

  resources :events
  # root to: "events#index"
end
