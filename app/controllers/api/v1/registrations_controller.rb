class Api::V1::RegistrationsController < Devise::RegistrationsController
	respond_to :json

  def create

    user = User.new
    user.username = user_params[:username]
    user.password = user_params[:password]
    user.password_confirmation = user_params[:password_confirmation]
    user.email = user_params[:email]
    if user.save
      render :json=> { :success=> true, :auth_token=>user.auth_token, :email=>user.email, :user_id=>user.id, :user_name=>user.username }, :status=>201
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>401
    end
  end

  def user_params
      params.fetch(:user, {}).permit(:email, :password, :password_confirmation, :username)
    end
end