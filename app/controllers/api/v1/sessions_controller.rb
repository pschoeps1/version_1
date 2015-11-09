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

    if resource.valid_password?(user_params[:password])
      sign_in("user", resource)
      resource.generate_authentication_token!
      resource.save
      render :json=> {:success=>true, :auth_token=>resource.generate_authentication_token!, :email=>resource.email, :user_id=>resource.id, :user_name=>resource.username }
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    puts "1"
    resource = User.find_by_email(user_params[:email])
    puts 2
    sign_out(resource)
    puts 3
    resource.generate_authentication_token!
    puts 4
    render :json=> { :success=>true }
    puts 5
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
      params.fetch(:user, {}).permit(:email, :password, :auth_token)
  end
end
