class Api::V1::FlagsController < ApplicationController
  def create
    flag = Flag.new
    resource = User.find_by_auth_token(auth_token: user_params[:auth_token])
    flag.user_id = resource.id
    flag.reporter_id = user_params[:reporter_id]
    flag.content = user_params[:content]
    flag.user_name = user_params[:user_name]

    if flag.save
      render :json=> {:success=>true}
    else
      render :json => {:success=>false}, :status=>401
    end
  end
  

  def show
  end
end