class UserNp < ActiveRecord::Base
  belongs_to :user
  belongs_to :networkprovider
  
  validates_presence_of :user_id, :networkprovider_id
end
