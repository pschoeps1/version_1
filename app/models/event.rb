class Event < ActiveRecord::Base
    belongs_to :group
    #mount_uploader :file, FileUploader
    validates :name, presence: true
    validates :start_at, presence: true
    #validates :end_at, presence: true
    #validate  :file_size
    

     def file_size
      if file.size > 20.megabytes
        errors.add(:file, "should be less than 20MB")
      end
    end
    
end
