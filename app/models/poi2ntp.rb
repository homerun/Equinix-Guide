class Poi2ntp < ActiveRecord::Base
  belongs_to :networkterminationpoint
  belongs_to :poi, :class_name => 'Pointsofinterest', :foreign_key => 'pointsofinterest_id'
  belongs_to :pointsofinterest
  belongs_to :prospect_networkterminationpoints, :class_name => 'Networkterminationpoint', :foreign_key => 'networkterminationpoint_id'
  belongs_to :all_networkterminationpoints, :class_name => 'Networkterminationpoint', :foreign_key => 'networkterminationpoint_id'
  belongs_to :connectiontype, :class_name => 'Poiconnectiontype', :foreign_key => 'poiconnectiontype_id'
  belongs_to :user
  belongs_to :status, :class_name => 'Prospectstatustype', :foreign_key => 'prospectstatustype_id'
  has_many   :contestlist_poi2ntps
  has_many   :notes, :class_name => 'Poi2ntpnote', :order => 'date_time DESC', :dependent => :destroy
   
  validates_presence_of :pointsofinterest_id, :networkterminationpoint_id,  :poiconnectiontype_id
  
  def identifier
    if self.prospectstatustype_id == 1 then
      return "#{poi.name} at #{self.networkterminationpoint.name}"
    else
      return "#{poi.name} at #{self.networkterminationpoint.name} (#{status.status_description})"
    end
  end
end
