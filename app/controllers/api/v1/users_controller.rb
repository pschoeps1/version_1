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
    #user = User.find(params[:id])
    user = User.find_by_auth_token(user_params[:auth_token])
    groups = user.groups
    followed_groups = user.following
    render json: {groups: groups + followed_groups}
    #respond_to do |format|
   # format.json  { render :json => {:groups=> groups, 
   #                               :followed_groups => followed_groups }}
   # end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end