class UserPoi < ActiveRecord::Base
  belongs_to :user
  belongs_to :pointsofinterest
  has_many :user_poi_notes, :dependent => :destroy, :order => 'date_time DESC'
  
  validates_presence_of :user_id, :pointsofinterest_id
end
