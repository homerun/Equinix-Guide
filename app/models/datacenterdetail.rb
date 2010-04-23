class Datacenterdetail < ActiveRecord::Base
  belongs_to :networkterminationpoint
  belongs_to :quality_type, :class_name => 'Qualitytype', :foreign_key => 'qualitytype_id'
  belongs_to :sprinkler_type, :class_name => 'Sprinklertype', :foreign_key => 'sprinklertype_id'
  belongs_to :ups_system_type, :class_name => 'Upssystemtype', :foreign_key => 'ups_system_type_id'
  belongs_to :market
  
  def identifier
    return "#{networkterminationpoint.name} (Datacenter)"
  end
  
  def market_name
    if self.market == nil then
      return self.networkterminationpoint.parentcountry.name
    else
      return self.market.market_name
    end
  end
  
  def floor_capacity_color
    return "0000ff" if self.occupancy_rate.nil?
    if self.occupancy_rate >= 90 then
      return "ff0000"
    elsif self.occupancy_rate >= 60 then
      return "ff8833"
    else
      return "00ff00"
    end
  end
  
  def occupied_floor_space
    return '"Unknown"' if (self.gross_floor_capacity_british.nil? and self.floor_capacity_british.nil?) or self.occupancy_rate.nil?
    return self.floor_capacity * (self.occupancy_rate/100.0)
  end
  
  def floor_capacity_percent(max)
    return 0.0 if self.gross_floor_capacity_british.nil? and self.floor_capacity_british.nil?
    return 0.5*(self.gross_floor_capacity_british**0.8)/max if self.floor_capacity_british.nil?
    return (self.floor_capacity_british**0.8)/max
  end
  
  def floor_capacity_radius
    return 0.4 if self.gross_floor_capacity_british.nil? and self.floor_capacity_british.nil?
    return 0.7 + 0.00003*(self.gross_floor_capacity_british**0.8) if self.floor_capacity_british.nil?
    return 0.7 + 0.00003*(self.floor_capacity_british**0.8)
  end
  
  def floor_capacity
    return 0 if self.gross_floor_capacity_british.nil? and self.floor_capacity_british.nil?
    return self.gross_floor_capacity_british if self.floor_capacity_british.nil?
    return self.floor_capacity_british
  end
end