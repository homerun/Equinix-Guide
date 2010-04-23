class Newsrating < ActiveRecord::Base
  belongs_to :newsitem
  belongs_to :user
  
  validates_presence_of :newsitem_id, :user_id
end