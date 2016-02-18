class Api::V1::SessionsController < Devise::SessionsController

  prepend_before_filter :require_no_authentication, :only => [:create]
  skip_before_filter :verify_signed_out_user
  #include Devise::Controllers::InternalHelpers
  
  #before_filter :ensure_params_exist

  respond_to :json
  
  def create
    #build_resource
    resource = User.find_for_database_authentication(email: user_params[:email])
    return invalid_login_attempt_2 unless resource

    device_id = user_params[:device_id] if user_params[:device_id]
    device_type = user_params[:device_type] if user_params[:device_type]
    if device_id
      registered_device = Device.find_by_token(device_id)
      if registered_device
        #do nothing
      else
        new_device = Device.create(:user_id => resource.id, :token => device_id, :device_type => device_type)
        new_device.save
      end
    end

    if resource.valid_password?(user_params[:password])
      sign_in("user", resource)
      resource.generate_authentication_token!
      resource.save
      render :json=> {:success=>true, :auth_token=>resource.auth_token, :email=>resource.email, :user_id=>resource.id, :user_name=>resource.username }
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    resource = User.find_by_email(user_params[:email])
    sign_out(resource)
    resource.generate_authentication_token!
    render :json=> { :success=>true }
  end

  protected

  def ensure_params_exist
    return unless params[:email].blank? 
    render :json=>{:success=>false, :message=>"missing email or password"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Invalid Password"}, :status=>401
  end

  def invalid_login_attempt_2
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Invalid Email"}, :status=>401
  end

  def user_params
      params.fetch(:user, {}).permit(:email, :password, :auth_token, :device_id, :device_type)
  end
end
