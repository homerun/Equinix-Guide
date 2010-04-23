class Poiowner < ActiveRecord::Base
  has_many :poi_children, :class_name => 'poi2poiowner'
  
  validates_presence_of :name
  validates_uniqueness_of :name
end