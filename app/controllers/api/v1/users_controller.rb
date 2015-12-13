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

  def dashboard
    user = User.find_by_auth_token(params[:auth_token])
    blocked_users = BlockedUser.where(:blocker_id => user.id)
    groups = user.groups
    followed_groups = user.following
    render json: { groups: groups + followed_groups, blocked_users: blocked_users}
    #respond_to do |format|
   # format.json  { render :json => {:groups=> groups, 
   #                               :followed_groups => followed_groups }}
   # end
  end

  def notifications
    group = Group.find_by_chat_id(params[:chat_id])
    users = Relationship.where(:followed_id => group.id)
    user_tokens = []
    users.each do |u|
      #users_id <<0 User.find(u.follower_id).id 
      user_tokens = User.find(u.follower_id).devices
      user_tokens.each do |t|
        user_tokens << t.token
      end
    end
    render json: { users: users_id }
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end