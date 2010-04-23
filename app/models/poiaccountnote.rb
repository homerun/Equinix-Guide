class Poiaccountnote < ActiveRecord::Base
  belongs_to :poi, :class_name => 'Pointsofinterest'
  belongs_to :user
  
  validates_presence_of :pointsofinterest_id, :user_id
  
  def identifier
    return "#{(poi.nil? ? pointsofinterest_id : poi.name)}"
  end
end