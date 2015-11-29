class Api::V1::GroupsController < ApplicationController
	def show
	  @posts = Post.where(:group_id => params[:group_id])
      render json { posts: @posts}
	end

end