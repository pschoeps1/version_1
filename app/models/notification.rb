class Notification < ActiveRecord::Base  
  after_save :push
  belongs_to :recipient, class_name: "User"

  # Pushes notification to each of the recipient's devices
  def push
    notifications = self.recipient.devices.map{|device|
      APNS::Notification.new(device.token,
        alert: self.alert,
      )
    }
    unless notifications.empty?
      APNS.send_notifications(notifications)
    end
  end
end 