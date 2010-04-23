class News2ntpowner < ActiveRecord::Base
  belongs_to :networktermptowner, :class_name => 'Networktermptowner', :foreign_key => :networktermptowner_id
  belongs_to :newsitem
  
  validates_presence_of :networktermptowner_id, :newsitem_id
end