class UserNtpOwner < ActiveRecord::Base
  belongs_to :user
  belongs_to :networktermptowner
  
  validates_presence_of :user_id, :networktermptowner_id
end
