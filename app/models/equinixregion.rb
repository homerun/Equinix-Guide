class Equinixregion < ActiveRecord::Base
  has_many :subregions, :class_name => 'Unsubregion', :order => 'name' 
  has_many :news2regions, :dependent => :destroy
  has_many :newsitems, :through => :news2regions
  has_many :countries, :through => :subregions
  
  validates_presence_of :region_name
  validates_uniqueness_of :region_name
  
  def networkterminationpoints
    ntps = Array.new
    self.countries.each do |country|
      ntps += country.networkterminationpoints
    end
    return ntps
  end
  
  def markets
    markets = Array.new
    self.countries.each do |country|
      markets += country.markets
    end
    return nil if markets.size == 0
    return markets
  end
end