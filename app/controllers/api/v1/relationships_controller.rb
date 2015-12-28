class Api::V1::RelationshipsController < ApplicationController

def destroy
	@user = User.find_by_auth_token(params[:follower_id]).id
	puts @user
    @relationship = Relationship.where(:follower_id=>@user).where(:followed_id=>params[:followed_id]).first
    @relationship.destroy
    if @relationship.destroy
      render :json=> {:success=>true}
    else
      render :json => {:success=>false}, :status=>401
    end
end

def create
	follower_id = User.find(params[:auth_token]).id
	followed_id = params[:followed_id]
	relationship = Relationship.new
	relationship.follower_id = follower_id
	relationship.followed_id = followed_id
	relationship.save

	if relationship.save
		render :json=> {:success=>true}
	else
		render :json=> {:success=>false}
	end
end
end