class Poitype < ActiveRecord::Base
  has_many :pois, :class_name => 'Pointsofinterest', :foreign_key => :pointsofinterest_id
  
  validates_presence_of :name
end