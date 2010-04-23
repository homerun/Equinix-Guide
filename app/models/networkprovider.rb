class Networkprovider < ActiveRecord::Base
  has_many :ntp_connections, :class_name => 'Np2ntp', :dependent => :destroy
  has_many :networkterminationpoints, :through => :ntp_connections
  
  has_many :preferred_pois, :class_name => 'Poipreferrednp', :dependent => :destroy
  belongs_to :region1contact, :class_name => 'User', :foreign_key => 'user_contact_region1'
  belongs_to :region2contact, :class_name => 'User', :foreign_key => 'user_contact_region2'
  belongs_to :region3contact, :class_name => 'User', :foreign_key => 'user_contact_region3'
  belongs_to :region4contact, :class_name => 'User', :foreign_key => 'user_contact_region4'
  
  has_many :user_nps, :dependent => :destroy
  has_many :users, :through => :user_nps
  
  has_many :np2dcs, :dependent => :destroy
  has_many :datacenters, :through => :np2dcs
  
  has_many :np2pois, :dependent => :destroy
  has_many :pointsofinterests, :through => :np2pois
  
  has_many :news2nps, :dependent => :destroy
  has_many :newsitems, :through => :new2nps
  
  has_many :inquiry_np2ntps, :dependent => :destroy
  has_many :inquiries, :through => :inquiry_np2ntps
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  
  def first_connection_to(networkterminationpoint_id)
    self.ntp_connections.each do |ntp_connection|
      return ntp_connection if ntp_connection.networkterminationpoint_id == networkterminationpoint_id
    end
    return nil
  end
end