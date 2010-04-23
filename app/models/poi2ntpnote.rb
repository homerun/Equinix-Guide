class Poi2ntpnote < ActiveRecord::Base
  belongs_to :user
  belongs_to :poi2ntp
  
  validates_presence_of :user_id, :poi2ntp_id
  
  def identifier
    if self.prospectstatustype_id == 1 then
      return "#{poi.name} at #{self.networkterminationpoint.name}"
    else
      return "#{poi.name} at #{self.networkterminationpoint.name} (#{status.status_description})"
    end
  end
end