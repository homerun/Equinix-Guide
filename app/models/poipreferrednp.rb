class Poipreferrednp < ActiveRecord::Base
  belongs_to :networkprovider
  belongs_to :poi, :class_name => 'Pointsofinterest', :foreign_key => :pointsofinterest_id
  belongs_to :connectiontype
  
  validates_presence_of :pointsofinterest_id, :networkprovider_id
  
  def identifier
    #"#{self.poi.name} preferred network provider"
  end
end