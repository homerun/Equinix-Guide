class CreateEquinixregions < ActiveRecord::Migration
  def self.up
    create_table :equinixregions do |t|
      t.string :region_name
      t.timestamps
    end
    
    ["United States", "Asia Pacific", "Europe", "Other"].each do |r|
      region = Equinixregion.new
      region.region_name = r
      region.save!  
    end
  end

  def self.down
    drop_table :equinixregions
  end
end
