class CreateUnregions < ActiveRecord::Migration
  def self.up
    create_table :unregions do |t|
      t.string :region_name
      t.timestamps
    end
    
    ["Asia", "Europe", "Africa", "Oceania", "Americas"].each do |r|
      region = Unregion.new
      region.region_name = r
      region.save! 
    end
  end

  def self.down
    drop_table :unregions
  end
end
