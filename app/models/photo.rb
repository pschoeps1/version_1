class Photo < ActiveRecord::Base
    belongs_to :group
     
    validates :photo, presence: true
    validate  :photo_size

  private

    # Validates the size of an uploaded picture.
    def photo_size
      if photo.size > 5.megabytes
        errors.add(:photo, "should be less than 5MB")
      end
    end
end
