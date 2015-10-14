class Api::V1::RegistrationsController < Devise::RegistrationsController
	respond_to :json

  def create

    user = User.new(user_params)
    if user.save
      render :json=> { :auth_token=>user.auth_token, :email=>user.email, :id=>user.id, :first_name=>user.first_name, :last_name=>user.last_name }, :status=>201
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end

  def user_params
      params.fetch(:user, {}).permit(:email, :password, :password_confirmation)
    end
end