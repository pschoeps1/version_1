#require 'api_constraints'

Version1::Application.routes.draw do
  devise_for :users
  # Api definition
  api_version(:module => "api/v1", :path => {:value => "v1"}, defaults: { format: :json }) do
      resources :users, :only => [:show, :update, :destroy] do
      	member do
          get 'dashboard'
          devise_scope :user do
            delete 'session' => 'sessions#destroy'
          end
        end
      end
      resources :groups, :only => [:show]
      devise_for :users, controllers: { sessions: "api/v1/sessions", registrations: "api/v1/registrations" }
      #resources :sessions, :only => [:create, :destroy]
  end
end
