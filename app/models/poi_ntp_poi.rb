class PoiNtpPoi < ActiveRecord::Base
  belongs_to :a_pointsofinterest, :class_name => 'Pointsofinterest', :foreign_key => 'a_pointsofinterest_id'
  belongs_to :b_pointsofinterest, :class_name => 'Pointsofinterest', :foreign_key => 'b_pointsofinterest_id'
  belongs_to :networkterminationpoint
end