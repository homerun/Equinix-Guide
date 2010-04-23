class News2region < ActiveRecord::Base
  belongs_to :region, :class_name => 'Equinixregion', :foreign_key => :equinixregion_id
  belongs_to :newsitem
   
  validates_presence_of :equinixregion_id, :newsitem_id
end