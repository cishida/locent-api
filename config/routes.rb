require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, at: '/resque'
  post 'status/:id', to: 'twilio#status'
  post 'receive', to: 'twilio#receive'


  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :opt_ins, only: [:create]
      post '/safetext', to: 'orders#safetext'
      post '/clearcart', to: 'orders#clearcart'
      post '/order_status', to: 'orders#order_status'
      post 'products', to: 'products#create'
      get 'products/:feature', to: 'products#show'
      put 'products/:uid', to: 'products#update'
      delete 'products/:uid', to: 'products#destroy'
    end
  end

  mount_devise_token_auth_for 'User', at: '/dashboard/auth', skip: [:omniauth_callbacks]
  namespace :dashboard, defaults: {format: :json} do
    scope module: :v1 do
      resources :organizations, only: [:show, :create, :index, :update, :destroy] do
        collection do
          get 'users'
          post 'create_users'
        end
      end
      put 'error_message/:code', to: 'organizations#update_error_message'
      resources :features, only: :index
      resources :customers, only: :show, param: :feature
      resources :subscriptions, only: [:create, :show] do
        member do
          get :options
          put :update_options
        end
      end
      post 'products', to: 'products#create'
      get 'products/:feature', to: 'products#show'
      put 'products/:uid', to: 'products#update'
      delete 'products/:uid', to: 'products#destroy'
      get 'orders/:feature', to: 'orders#orders'
    end
  end

end

