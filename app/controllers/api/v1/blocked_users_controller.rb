class Api::V1::BlockedUsersController < ApplicationController

	def create

     blocked_user = BlockedUser.create
     blocked_user.blocker_id = User.find(params[:auth_token]).id
     blocked_user.blocked_id = params[:blocked_id]
      if blocked_user.save
        render :json=> { :success=>true, }, :status=>201
        return
      else
        render :json=> { :success=>false }, :status=>422
      end
    end

    def show
    	user = User.find(params[:auth_token])
    	blocked_users = BlockedUser.where(:blocker_id => user.id)

    	if blocked_users
    		render :json=> { blocked_users: blocked_users}
    	else
    		render :json => {"none"}
    	end
    end
end