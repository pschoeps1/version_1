class Api::V1::RelationshipsController < ApplicationController

def destroy
	@user = User.find_by_auth_token(params[:auth_token]).id
	puts @user
    @relationship = Relationship.where(:follower_id=>@user).where(:followed_id=>params[:followed_id]).first
    @relationship.destroy
    if @relationship.destroy
      render :json=> {:success=>true}
    else
      render :json => {:success=>false}, :status=>401
    end
end
end