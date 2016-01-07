require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, at: '/resque'
  post 'status/:id', to: 'twilio#status'
  post 'receive', to: 'twilio#receive'


  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :opt_ins, only: [:create]
      resources :safetext, only: [:create] do
        post 'order_status'
      end
    end
  end

  mount_devise_token_auth_for 'User', at: '/dashboard/auth', skip: [:omniauth_callbacks]
  namespace :dashboard, defaults: {format: :json} do
    scope module: :v1 do
      resources :organizations, only: [:show, :create, :index, :update, :destroy] do
      end
      resources :products, only: :index
      resources :safetext, except: [:all] do
        collection do
          get "customers"
        end
      end
      resources :subscriptions, only: [:create, :show] do
        member do
          get :options
          put :update_options
        end
      end
    end
  end

end

