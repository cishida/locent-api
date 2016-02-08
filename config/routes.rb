require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, at: '/resque'
  post 'status/:id', to: 'twilio#status'
  post 'receive', to: 'twilio#receive'


  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :opt_ins, only: [:create]
      put '/opt_out', to: 'opt_ins#opt_out'
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
          put 'update_user_admin_status'
        end
      end
      delete 'organizations/destroy_user/:id', to: 'organizations#destroy_user'
      put 'error_message/:code', to: 'organizations#update_error_message'
      resources :features, only: :index
      resources :customers, only: :show, param: :feature
      get 'customers/:uid/messages/:feature', to: 'customers#messages'
      resources :campaigns, only: :index
      post 'campaigns/alert/:feature', to: 'campaigns#alert'
      post 'campaigns/import', to: 'campaigns#import'
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
      resources :shortcode_applications, only: :create
      get 'stats/:feature/:from/:to', to: 'stats#stats'
    end
  end

  mount_devise_token_auth_for 'SuperAdmin', at: '/superadmin/auth', skip: [:omniauth_callbacks]
  namespace :superadmin, defaults: {format: :json} do
    scope module: :v1 do
      resources :shortcode_applications, only: :index do
        member do
          put 'update_status'
          post 'assign_shortcode_to_organization'
        end
      end
    end
  end

end

