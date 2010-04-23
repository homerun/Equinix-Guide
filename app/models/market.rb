class Market < ActiveRecord::Base
  belongs_to :country
  has_many :datacenters, :class_name => 'Datacenterdetail', :foreign_key => 'market_id', :dependent => :nullify
  has_many :news2markets, :dependent => :destroy
  has_many :newsitems, :through => :news2markets
  
  def max_floor_capacity
    max = 1.0
    self.datacenters.each do |datacenter|
      max = datacenter.floor_capacity_british if !datacenter.floor_capacity_british.blank? and datacenter.floor_capacity_british > max
    end
    return max
  end
end