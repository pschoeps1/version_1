class Api::V1::BlockedUsersController < ApplicationController

	def create

     blocked_user = BlockedUser.create
     blocked_user.blocker_id = User.find_by_auth_token(params[:auth_token]).id
     blocked_user.blocked_id = params[:blocked_id]
      if blocked_user.save
        render :json=> { :success=>true, }, :status=>201
        return
      else
        render :json=> { :success=>false }, :status=>422
      end
    end

    def destroy
    	user = User.find_by_auth_token(params[:auth_token]).id
    	relationship = BlockedUser.where(:blocker_id=>user).where(:blocked_id=>params[:blocked_id]).first
    	relationship.destroy

    	if relationship.destroy
    		render :json=> {:success=>true,}, :status=>201
    	else
    		render :json => { :success=>false}, :status=>422
    	end
    end
end