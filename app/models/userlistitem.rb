class Userlistitem < ActiveRecord::Base
  belongs_to :user
  belongs_to :userlist
  
  validates_presence_of :user_id, :userlist_id
end
