Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do

  end

  namespace :dashboard, defaults: {format: :json}  do
    scope module: :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
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

