class CampusNtp2ntp < ActiveRecord::Base
  belongs_to :campus
  belongs_to :campus_access_type
  belongs_to :networkterminationpoint_a, :class_name => 'Networkterminatoinpoint', :foreign_key => 'a_networkterminationpoint_id'
  belongs_to :networkterminationpoint_b, :class_name => 'Networkterminatoinpoint', :foreign_key => 'b_networkterminationpoint_id'
  
  def self.identifier
    return "#{self.networkterminationpoint_a.name} and #{self.networkterminationpoint_b.name}"
  end
end