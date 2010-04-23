class CreatePoiconnectiontypes < ActiveRecord::Migration
  def self.up
    create_table :poiconnectiontypes do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    type = Poiconnectiontype.new
    type.name = "A"
    type.description = "Matching engines or application servers inside facility."
    type.save!
    
    type = Poiconnectiontype.new
    type.name = "B"
    type.description = "Access Center or Network Point of Presence (POP) inside facility. No LEC/PTT needed, just cross-connect within facility."
    type.save!
    
    type = Poiconnectiontype.new
    type.name = "C"
    type.description = "Unknown"
    type.save!
    
    type = Poiconnectiontype.new
    type.name = "E"
    type.description = "None, site is not a network termination point but it is the only known location."
    type.save!
    
    type = Poiconnectiontype.new
    type.name = "D"
    type.description = "Available via IBX from another on-campus facility."
    type.save!
  end

  def self.down
    drop_table :poiconnectiontypes
  end
end
