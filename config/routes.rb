#require 'api_constraints'

Version1::Application.routes.draw do
  devise_for :users
  # Api definition
  api_version(:module => "api/v1", :path => {:value => "v1"}, defaults: { format: :json }) do
      resources :users, :only => [:show, :update, :destroy, :index] do
      	member do
          get 'dashboard'
          get 'notifications'
          get 'inbox'
          get 'all_events'
        end
      end
      #needed to specify sign out path because it was incorrectly routing upon deployment
      devise_scope :user do
        delete 'sign_out' => 'sessions#destroy'
      end

      resources :groups, :only => [:show, :index, :create, :edit, :destroy] do
        get 'multiple_invites'
        get 'members'
        get 'upload_photo'

        resources :events
      end

      resources :friendships, :only => [:destroy, :index] do 
         member do
           post 'accept'
           post 'decline'
           post 'delete'
          end
      end
      resources :posts, :only => [:show]
      resources :flags, :only => [:create]
      resources :blocked_users, :only => [:create]
      resources :devices, :only => [:create]
      match 'relationships/destroy'   => 'relationships#destroy',    :via => :delete
      match 'relationships/create'    => 'relationships#create',     :via => :get
      match 'blocked_users/destroy'   => 'blocked_users#destroy',    :via => :delete
      match 'friendships/create'      => 'friendships#create',       :via => :get
      #match 'groups/multiple_invites' => 'groups#multiple_invites',   :via => :get
      #match 'users/notifications' => 'users#notifications',     :via => :get
      devise_for :users, controllers: { sessions: "api/v1/sessions", registrations: "api/v1/registrations" }
      #resources :sessions, :only => [:create, :destroy]
  end
end
