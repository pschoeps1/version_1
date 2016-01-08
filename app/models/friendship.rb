class Friendship < ActiveRecord::Base
    belongs_to :user
    belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
    
    validates :user_id, presence: true
    validates :friend_id, presence: true
    
    #return true if users are pending, possible friends
    def self.exists?(user, friend)
        not find_by_user_id_and_friend_id(user, friend).nil?
    end
    
    #record a pending friend request
    def self.request(user, friend)
        unless user == friend or Friendship.exists?(user, friend)
          transaction do
              create(:user => user, :friend => friend, :status => 'pending')
              create(:user => friend, :friend => user, :status => 'requested')
          end
        end
    end
    
    #accepts a friendship
    def self.accept(user, friend)
        transaction do
            accepted_at = Time.now
            accept_one_side(user, friend, accepted_at)
            accept_one_side(friend, user, accepted_at)
        end
    end
    
    #deletes a friendship
    def self.breakup(user, friend)
        transaction do
            destroy(find_by_user_id_and_friend_id(user, friend))
            destroy(find_by_user_id_and_friend_id(friend, user))
        end
    end
    
    private
    
    #Update the db with one side of an accepted friendship request
    def self.accept_one_side(user, friend, accepted_at)
        request = find_by_user_id_and_friend_id(user, friend)
        request.status = 'accepted'
        request.accepted_at = accepted_at
        request.save!
    end
            
            
            
end
