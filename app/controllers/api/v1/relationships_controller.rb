class Api::V1::RelationshipsController < ApplicationController

def destroy
    @relationship = Rrelationship.find_by_follower_id_and_followed_id(params[:follower_id],params[:followed_id])
    @relationship = @relationship_find.destroy
    render :json=> {:success=>true}
  end
end