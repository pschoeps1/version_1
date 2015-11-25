class Flag < ActiveRecord::Base

  validates :user_id, presence: true
  validates :reporter_id, presence: true
 
end
