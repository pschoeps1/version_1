class Api::V1::GroupsController < ApplicationController
	def show
	  @posts = Post.where(:group_id => params[:id])
      render json: @posts
	end

	def index
	  @groups = Group.search(params[:query]).where(:privacy => false)
      #@user = current_user
      #@group_show = @user.groups.where(params[:privacy], false)
      #@group_find = Group.find_by_id(params[:id])
      render :json=> { :groups => @groups }
	end

end