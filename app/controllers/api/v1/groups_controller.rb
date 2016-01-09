class Api::V1::GroupsController < ApplicationController
	respond_to :html, :json
	def show
	  @posts = Post.where(:group_id => params[:id])
      render json: @posts
	end

	def index
	  user = User.find(params[:user_id])
	  user_groups = user.groups
	  if (params[:search])
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
			render :json => { :success => false }, :status=>401
		end
	end

	def destroy
		user = User.find_by_auth_token(params[:auth_token])
		group = Group.find(params[:id])
		if user.id == group.user_id
			group.destroy
		end

		if group.destroy
			render :json => { :success => true }
		else
			render :json => { :success => false }, :status=>401
		end
	end

	def edit
		group = Group.find(params[:group_id])
		group.name = params[:group_name]
		group.teacher = params[:group_owner] if params[:group_owner]
		group.privacy = params[:privacy]
		group.description = params[:group_description] if params[:group_description]
		group.members_can_edit = params[:members_events]
		group.save

		if group.save
			render :json => { :success => true }
		else
			render :json => { :success => false }, :status=>401
		end
	end

	def members
		user = User.find_by_auth_token(params[:auth_token])
		if user
		  group = Group.find(params[:group_id])
		  @relationships = Relationship.where(:followed_id => group.id)
		  users = []
		  @relationships.each do |r|
		  	user = User.find(r.following.id)
		  	users << user
		  end
		  render :json => { :members => users }
		else
		  render :json => { :members => "none" }
		end
	end

	def multiple_invites
    #split emails by comma and determine if the recipient is a new or existing user, send emails to each, also check to see if a relationship already exists for that user
    if params[:multiple_invites].present?
      emails = params[:multiple_invites].split(', ')
      emails.each do |email|
        @invite = Invite.new # Make a new Invite
        @group = Group.find(params[:group_id])
        @invite.sender_id = params[:user_id] # set the sender to the current user
        @invite.sender_name = User.find(params[:user_id]).username
        @invite.group_name = @group.name
        @invite.group_id = @group.id
        @invite.email = email
        if @invite.save
          if @invite.recipient != nil
            InviteMailer.existing_user_invite(@invite, new_user_session_path).deliver
             #Add the user to the user group
             #check if a relationship exists, and if it does only send an email.
               if @invite.recipient.relationships.exists? followed_id: @group.id || @invite.sender_id == @group.user_id
               else
                 @invite.recipient.relationships.create!(followed_id: @group.id)
               end
        else
          #otherwise the recipient is a new user and needs to sign up with a token
          InviteMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)).deliver
        end
      end
      end
      render :json => { :success => true }
    end
  end

end