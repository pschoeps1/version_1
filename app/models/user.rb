class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups, dependent: :destroy
  has_many :relationships,        foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :following, through: :relationships, source: :followed
  has_many :devices, dependent: :destroy
  #validates :auth_token, uniqueness: true
  validates :email,      uniqueness: true


  before_create :generate_authentication_token!

  def generate_authentication_token!
    begin
      self.auth_token = SecureRandom.uuid
    end
    #end while self.class.exists?(auth_token: auth_token)
  end

  # Returns true if the current user is following a group.
  def following?(group)
    Relationship.exists? follower_id: id, followed_id: group.id
  end

  def self.search(search)
    if search
      self.where('username LIKE ?', "%#{search}%") 
      self.where('email LIKE ?', "%#{search}%")
    else
      self.all
    end
  end

  def as_json(options={})
    super(:only => [:username, :email, :id])
  end
end
