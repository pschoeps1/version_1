class Api::V1::RelationshipsController < ApplicationController

def destroy
	@user = User.find_by_auth_token(params[:auth_token]).id
    @relationship = Rrelationship.find_by_follower_id_and_followed_id(@user, params[:followed_id])
    @relationship = @relationship_find.destroy
    if @relationship.destroy
      render :json=> {:success=>true}
    else
      render :json => {:success=>false}, :status=>401
    end
end
end