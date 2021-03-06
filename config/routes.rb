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
        resources :attachments, only: :destroy do
        end
      end
    end

    resources :materials do
      resources :teachingfiles do
        resources :attachments, only: :destroy do
        end
      end
    end

    resources :classrooms do
      resources :topics do
        resources :teachingfiles do
          member do
            post :addfile
            post :removefile
          end
        end
        
        resources :aims
      end
    end

    resources :subjects

    resources :events

    resources :lessons do
      collection do
        get :list
      end
    end
  end

end