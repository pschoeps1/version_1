class Api::V1::GroupsController < ApplicationController
	def show
	  @posts = Post.where(:group_id => params[:id])
      render json: @posts
	end

	def index
	  user = User.find(params[:user_id])
	  user_groups = user.groups
	  if (params[:search])
	  	puts params[:search]
	    @groups = Group.search(params[:search]).where(:privacy => false)
	  else
	  	@groups = Group.where(:privacy=>false).last(20).reverse
	  end
	  new_groups = []
	  @groups.each do |g|
	  	unless g.user_id = user.id || Relationship.find(:followed_id=> g.id, :follower_id=> user.id)
	  		new_groups << g
	  	end
	  end
      #@user = current_user
      #@group_show = @user.groups.where(params[:privacy], false)
      #@group_find = Group.find_by_id(params[:id])
      render :json=> { :groups => new_groups}
	end

end