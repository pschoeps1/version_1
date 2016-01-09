class Api::V1::FriendshipsController < ApplicationController
    before_filter :setup_friends
    
    #send a friend request
    def create
        Friendship.request(@user, @friend)
        @friend = Friendship.find_by_user_id_and_friend_id(@user, @friend)
        render :json => { :success => true, :new_friend => @friend }
    end
    
    def index
        user = User.find_by_auth_token(params[:auth_token])
        @friendships = Friendship.where(:user_id => user.id).where(:status => "accepted")
        @friends = []
        @friendships.each do |f|
            user = User.find(f.friend_id)
            @friends << user
        end
        
        @group_users
        @relationships = Relationship.where(:group_id => params[:group_id])
        @relationships.each do |r|
            user = User.find(r.follower_id)
            @group_users << user
        end
        render :json => { :friends => @friends, :group_users => @group_users }
    end


    def accept
        if @user.requested_friends.include?(@friend)
            Friendship.accept(@user, @friend)
            render :json => { :success => true, :friendship => "accepted" }
        end
    end
    
    def decline
        if @user.requested_friends.include?(@friend)
            Friendship.breakup(@user, @friend)
            render :json => { :success => true , :friendship => "declined"}
        end
    end
    
    def delete
        if current_user.friends.include?(@friend)
            Friendship.breakup(current_user, @friend)
            flash[:success] = "Friend Removed"
            redirect_to :back
        end
    end
    
    def setup_friends
        if params[:friend_id]
          @friend = User.find(params[:friend_id])
        end
        @user = User.find_by_auth_token(params[:auth_token])
    end

end
