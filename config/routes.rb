require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, at: '/resque'

  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
      resources :opt_ins, only: [:create] do
        collection do
          get 'test_message'
        end
      end
    end
  end

  namespace :dashboard, defaults: {format: :json} do
    scope module: :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
      resources :organizations, only: [:show, :create, :index, :update, :destroy]
      resources :products, only: :index
      resources :subscriptions, only: [:create, :show] do
        member do
          get :options
          put :update_options
        end
      end
    end
  end

end

