class Poi2ntpprospect < ActiveRecord::Base
  belongs_to :networkterminationpoint
  belongs_to :poi, :class_name => 'Pointsofinterest', :foreign_key => 'pointsofinterest_id'
  belongs_to :connectiontype, :class_name => 'Poiconnectiontype', :foreign_key => 'poiconnectiontype_id'
  belongs_to :status, :class_name => 'Prospectstatustype', :foreign_key => 'prospectstatustype_id'
  has_many   :notes, :class_name => 'Poi2ntpprospectnote', :order => 'date_time DESC', :dependent => :destroy
  
  validates_presence_of :pointsofinterest_id, :networkterminationpoint_id, :prospectstatustype_id, :poiconnectiontype_id
  
  def identifier
    return "#{poi.name} at #{networkterminationpoint.name} (#{status.status_description})"
  end
end