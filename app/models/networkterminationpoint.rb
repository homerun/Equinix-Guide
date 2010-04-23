class Networkterminationpoint < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Networktermptowner', :foreign_key => 'networktermptowner_id'
  belongs_to :type, :class_name => 'Networktermpttype', :foreign_key => 'networktermpttype_id'
  
  has_many :np_connections, :class_name => 'Np2ntp'
  has_many :networkproviders, :through => :np_connections
  
  has_many :poi_connections, :class_name => 'Poi2ntp', :dependent => :destroy, :conditions => 'poi2ntps.prospectstatustype_id = 1'
  has_many :pois, :through => :poi_connections
  
  has_many :prospect_poi_connections, :class_name => 'Poi2ntp', :dependent => :destroy, :conditions => 'poi2ntps.prospectstatustype_id <> 1'
  has_many :prospect_pointsofinterests, :through => :prospect_poi_connections
  
  has_many :all_poi_connections, :class_name => 'Poi2ntp', :dependent => :destroy
  has_many :all_pointsofinterests, :through => :all_poi_connections

  belongs_to :parentcountry, :class_name => 'Country', :foreign_key => :country_id
  has_one :datacenterdetail, :class_name => 'Datacenterdetail', :foreign_key => :networkterminationpoint_id, :dependent => :destroy
  belongs_to :campus
  belongs_to :country
  
  has_many :inquiries, :through => :inquiry_np2ntps
  has_many :networkprovider_inquiries, :through => :inquiry_np2ntps
  
  belongs_to :campus_access_type
  
  validates_presence_of :name, :networktermpttype_id, :networktermptowner_id, :country_id
  validates_uniqueness_of :name
  
  # Change the name of the column for validation
  HUMANIZED_COLUMNS = {
    :networktermpttype_id => "Type", 
    :networktermptowner_id => "Owner"
    }
  
  def self.human_attribute_name(attribute)
    HUMANIZED_COLUMNS[attribute.to_sym] || super
  end
  
  def print_full_addr
    returnString = ''
    returnString += self.street_address
    returnString += "<br/>Floor: #{self.floor}" if self.floor != nil and !self.floor.blank?
    returnString += "<br/>Suite: #{self.suite}" if self.suite != nil and !self.suite.blank?
    returnString += "<br/>#{self.city}" if self.city != nil and !self.city.blank?
    returnString += ", #{self.state_or_province}" if self.state_or_province != nil and !self.state_or_province.blank?
    returnString += " #{self.zip_code}" if self.zip_code != nil and !self.zip_code.blank?
    returnString += "<br/>#{self.parentcountry.name}" if self.parentcountry != nil
    returnString
  end
  
  def one_line_addr
    returnString = ''
    returnString += self.street_address
    returnString += ", #{self.city}" if self.city != nil and !self.city.blank?
    returnString += ", #{self.state_or_province}" if self.state_or_province != nil and !self.state_or_province.blank?
    returnString += ", #{self.parentcountry.name}" if self.parentcountry != nil
    returnString
  end
  
  def is_datacenter?
    self.networktermpttype_id == Networktermpttype.find_by_name('Datacenter').id
  end  

  def networkterminationpoint_connections_through(networkprovider_id)
    ntp_connections = Array.new
    networkprovider = Networkprovider.find_by_id(networkprovider_id)
    if networkprovider then
      networkprovider.ntp_connections.each do |ntp_connection|
        ntp_connections << ntp_connection unless ntp_connection.networkterminationpoint_id == self.id
      end
    else
      self.networkproviders.each do |networkprovider|
        networkprovider.ntp_connections.each do |ntp_connection|
          ntp_connections << ntp_connection unless ntp_connection.networkterminationpoint_id == self.id
        end
      end
      ntp_connections.uniq!
    end
    return ntp_connections
  end

  def networkterminationpoints_through(networkprovider_id)
    networkterminationpoints = Array.new
    networkprovider = Networkprovider.find_by_id(networkprovider_id)
    if networkprovider and !networkprovider_id.nil? then
      networkprovider.networkterminationpoints.each do |networkterminationpoint|
        networkterminationpoints << networkterminationpoint unless networkterminationpoint.id == self.id
      end
    else
      self.networkproviders.each do |networkprovider|
        networkprovider.networkterminationpoints.each do |networkterminationpoint|
          networkterminationpoints << networkterminationpoint unless networkterminationpoint.id == self.id
        end
      end
      networkterminationpoints.uniq!
    end
    return networkterminationpoints
  end
  
  def networkproviders_connecting_to(networkterminationpoint_id)
    networkproviders = Array.new
    self.networkproviders.each do |networkprovider|
      networkproviders << networkprovider if networkterminationpoint_id.nil? or networkterminationpoint_id.blank? or networkprovider.networkterminationpoints.collect {|ntp| ntp.id }.include?(networkterminationpoint_id)
    end
    networkproviders.uniq!
    return networkproviders  
  end
  
  def connections_connecting_to(networkterminationpoint_id)
    connections = Array.new
    self.np_connections.each do |np_connection|
      second_connection = np_connection.networkprovider.first_connection_to(networkterminationpoint_id)
      connections << [np_connection.id,second_connection.id] unless second_connection.nil?
    end
    return connections  
  end
  
  def connections_to(networkprovider_id)
    connections = Array.new
    self.np_connections.each do |np_connection|
      connections << np_connection if np_connection.networkprovider_id == networkprovider_id
    end
    return connections
  end
  
  def first_connection_to(networkprovider_id)
    self.np_connections.each do |np_connection|
      return np_connection if np_connection.networkprovider_id == networkprovider_id
    end
    return nil
  end
  
  def campus_connection_to(ntp)
    return CampusNtp2ntp.find(:first,:conditions => ["a_networkterminationpoint_id = :a_ntp_id and b_networkterminationpoint_id = :b_ntp_id", {:a_ntp_id => [self.id,ntp.id].min, :b_ntp_id => [self.id,ntp.id].max}])
  end
  
  def distance_to(ntpOther,preference='B',number_only=false)
    if ntpOther.lat.blank? or ntpOther.lon.blank? or self.lat.blank? or self.lon.blank? or self == ntpOther then
      if number_only then
        return 0
      else
        return ''
      end
    end
    other_lat = ntpOther.lat.to_f
    other_lon = ntpOther.lon.to_f
    self_lat = self.lat.to_f
    self_lon = self.lon.to_f
    to_rads = Math::PI / 180.0
    begin
      d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    rescue
      return ''
    end
    if preference == 'B' then
      if number_only then
        ((d * 100).round.to_f / 100)
      else
        "#{((d * 100).round.to_f / 100)} km"
      end
    else
      if number_only then
        (d * 62.1371192).round.to_f / 100
      else
        "#{(d * 62.1371192).round.to_f / 100} miles"
      end
    end
  end
end