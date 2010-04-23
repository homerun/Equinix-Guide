class Np2dc < ActiveRecord::Base
  belongs_to :networkprovider
  belongs_to :datacenter
  belongs_to :connectiontype
  
  validates_presence_of :networkprovider_id, :datacenter_id, :connectiontype_id
end 
