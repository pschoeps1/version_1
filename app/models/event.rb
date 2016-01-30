class Event < ActiveRecord::Base
    belongs_to :group
    #mount_uploader :file, FileUploader
    validates :name, presence: true
    validates :start_at, presence: true
    #validates :end_at, presence: true
    #validate  :file_size

    #attr_accessible :id, :name, :group_id, :content, :start_at, :end_at

    default_scope -> { order(created_at: :desc) }
    

     def file_size
      if file.size > 20.megabytes
        errors.add(:file, "should be less than 20MB")
      end
    end
    
end
