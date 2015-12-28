class Group < ActiveRecord::Base
   belongs_to :user
   #has_many :events, dependent: :destroy
   
   has_many :relationships,        foreign_key: "followed_id",
                                   dependent:   :destroy
   has_many :followers, through: :relationships, source: :follower, dependent: :destroy
   accepts_nested_attributes_for :user

   
   default_scope -> { order(created_at: :desc) }
   validates :user_id, presence: true
   validates :name, presence: true, length: { maximum: 35 }



   def self.search(search)
    if search
      self.where('name LIKE ?', "%#{search}%")
    else
      self.all
    end
  end
end
