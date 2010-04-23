class Poistoloc < ActiveRecord::Base
  belongs_to :poiloc, :class_name => 'Poilocation'
  belongs_to :poi, :class_name => 'Pointsofinterest'
  
  validates_presence_of :pointsofinterest_id, :poilocation_id
end