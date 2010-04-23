class UserPoiNote < ActiveRecord::Base
  belongs_to :user_poi
  belongs_to :user
  
  validates_presence_of :user_poi_id
end
