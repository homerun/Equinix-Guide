class News2poi < ActiveRecord::Base
  belongs_to :poi, :class_name => 'Pointsofinterest', :foreign_key => :pointsofinterest_id
  belongs_to :newsitem
  
  validates_presence_of :pointsofinterest_id, :newsitem_id
end