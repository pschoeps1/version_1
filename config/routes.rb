#require 'api_constraints'

Version1::Application.routes.draw do
  devise_for :users
  # Api definition
  api_version(:module => "api/v1", :path => {:value => "v1"}, defaults: { format: :json }) do
      resources :users, :only => [:show, :update, :destroy] do
      	member do
          get 'dashboard'
        end
      end
      #needed to specify sign out path because it was incorrectly routing upon deployment
      devise_scope :user do
        delete 'sign_out' => 'sessions#destroy'
      end

      resources :groups, :only => [:show]
      resources :flags, :only => [:create]
      devise_for :users, controllers: { sessions: "api/v1/sessions", registrations: "api/v1/registrations" }
      #resources :sessions, :only => [:create, :destroy]
  end
end
