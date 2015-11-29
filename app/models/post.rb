class Post < ActiveRecord::Base
    belongs_to :group
    
    default_scope -> { order(created_at: :desc) }
    validates :title, presence: true, length: { maximum: 35 }
    validates :post, presence: true
end