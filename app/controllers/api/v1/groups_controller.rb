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
	    #@groups = Group.search(params[:search]).where(:privacy => false)
	    search = params[:search]
	    @groups = Group.where('name LIKE ?', "%#{search}%").where(:privacy => false)
	  else
	  	@groups = Group.where(:privacy=>false).last(20).reverse
	  end
	  joined_groups = []
	  @groups.each do |g|
	  	if g.user_id == user.id || Relationship.find_by_followed_id_and_follower_id(g.id, user.id)
	  		joined_groups << g.id
	  	end
	  end
      render :json=> { :groups => @groups, :joined => joined_groups }
	end

end