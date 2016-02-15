class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  #respond_to :json

  def show
    user = User.find(params[:id])
    render :json=> { :email=>user.email, :user_id=>user.id }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:v1, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200, location: [:v1, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  def index
    user = User.find(params[:user_id])
    @friends = Friendship.where(:user_id => user.id)
    if (params[:search])
      search = params[:search]
      @users = User.where('username LIKE ?', "%#{search}%") || User.where('email LIKE ?', "%#{search}%")
    else
      @users = User.last(20).reverse
    end
    render :json => { :users => @users, :friends => @friends }
  end

  def inbox
    user = User.find_by_auth_token(params[:auth_token])
    users = user.requested_friends
    render :json => { :pending_friends => users }
  end

  def dashboard
    user = User.find_by_auth_token(params[:auth_token])
    blocked_users = BlockedUser.where(:blocker_id => user.id)
    groups = user.groups
    followed_groups = user.following
    render json: { groups: groups + followed_groups, blocked_users: blocked_users }
  end

  def notifications
    group = Group.find_by_chat_id(params[:chat_id])
    group_name = group.name
    group_id = group.id
    owner = User.find(group.user_id)
    relationships = Relationship.where(:followed_id => group.id)
    user_tokens = []
    relationships.each do |u|
      user = User.find(u.follower_id)
      devices = user.devices
      devices.each do |d|
        user_tokens << d.token
      end
    end
    owner_devices = owner.devices
    owner_devices.each do |o|
      user_tokens << o.token
    end
    render json: { users: user_tokens, group_name: group_name, group_id: group_id }
  end

  def all_events
    user = User.find_by_auth_token(params[:auth_token])
    groups = user.groups 
    events = []
    groups.each do |group|
      group_events = group.events 
      if group.events.length > 5
        last_events = group.events.last(5)
        last_events.each do |event|
          events << event 
        end
      else
        events << group.events 
        events.each do |event|
          events << event 
        end
      end
    end

    render json: { events: events }
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end