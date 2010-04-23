class Poi2poiowner < ActiveRecord::Base
  belongs_to :poiowner
  belongs_to :poi, :class_name => 'Pointsofinterest'
  
  validates_presence_of :pointsofinterest_id, :poiowner_id
end