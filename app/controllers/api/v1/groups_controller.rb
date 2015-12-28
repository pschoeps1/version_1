class Api::V1::GroupsController < ApplicationController
	def show
	  @posts = Post.where(:group_id => params[:id])
      render json: @posts
	end

	def index
	  if (params[:search])
	  	puts params[:search]
	    @groups = Group.search(params[:search]).where(:privacy => false)
	  else
	  	@groups = Group.where(:privacy=>false).last(20).reverse
	  end
      #@user = current_user
      #@group_show = @user.groups.where(params[:privacy], false)
      #@group_find = Group.find_by_id(params[:id])
      render :json=> { :groups => @groups }
	end

end