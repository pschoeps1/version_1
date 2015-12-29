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

	def create
		group = Group.new
		group.name = params[:group_name]
		group.teacher = params[:group_owner] if params[:group_owner]
		group.user_id = User.find_by_auth_token(params[:auth_token]).id
		group.chat_id = params[:chat_id]
		group.privacy = params[:privacy]
		group.description = params[:group_description] if params[:group_description]
		group.members_can_edit = params[:members_events]

		if group.save
			render :json => { :success => true }
		else
			render :json => { :success => false }
		end
	end

end