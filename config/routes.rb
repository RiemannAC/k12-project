Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "users#show"

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :photos, only: [:index, :create, :show, :update, :destroy]
    end
  end

  resources :subject_tags

  resources :users do
    member do
      get :viewfile
    end

    resources :plans do
      resources :teachingfiles do
        member do
          post :addfile
          post :removefile
        end
        resources :attachments, only: :destroy
      end
    end

    resources :materials do
      resources :teachingfiles do
        member do
          post :addfile
          post :removefile
        end
        resources :attachments, only: :destroy
      end
    end

    resources :subjects do
      resources :topics do
        resources :aims
      end
    end

    resources :events
    get '/test' => 'calendar#test'


    resources :lessons do
      collection do
        get :list
      end
    end
  end

end