class Np2ntp < ActiveRecord::Base
  belongs_to :networkterminationpoint
  belongs_to :networkprovider
  belongs_to :connectiontype
  belongs_to :user
  has_many   :contestlist_np2ntps
  has_many   :connection_services
  belongs_to :owner, :class_name => 'Networkprovider', :foreign_key => 'owner_networkprovider_id'
  
  validates_presence_of :networkterminationpoint_id, :networkprovider_id
  
  def identifier
    return "#{networkprovider.name} to #{networkterminationpoint.name}"
  end
  
  def details
    if not NEW_CONNECTIONS then
      return self.connectiontype.type_description unless self.connectiontype.nil?
      return "."
    end
    if self.connection_services.blank? and self.connection_type.blank? and self.multiple_access.blank? and self.available.blank? then
      unless self.connectiontype.nil?
        return self.connectiontype.type_description
      end
      return "_"
    end
    services = ''
    services = " and provides the following services: #{(self.connection_services.collect {|srv| srv.connection_service_description.to_str}).join(', ')}" unless self.connection_services.blank?
    if self.available == 'Y' then
      owner = ''
      if self.networkprovider.carrier_type == true then
        owner = ((self.owned == 'L')?("#{((self.owner.nil?)?('someone'):(self.owner.name))}'s"):((self.owned == 'U')?('unknown'):('their own')))
      else
        owner = ((self.owner.nil?)?('unknown'):("#{self.owner.name}'s"))
      end
      if self.networkprovider.carrier_type == true then
        multiple_access = ((self.multiple_access=='Y')?('with multiple entries'):((self.multiple_access == 'U')?('with unknown entries'):('with single entry')))
      else
        multiple_access = ((self.multiple_access=='Y')?('with multiple customer access node'):((self.multiple_access == 'U')?('with unknown access node'):('with single connection')))
      end
      connection_type = ((self.connection_type == 'C')?('Copper'):((self.connection_type == 'U')?('connection'):('Fiber')))
      return "In Building via #{owner} #{connection_type} #{multiple_access}#{services}."
    else
      return "Not In Building"
    end
  end
end