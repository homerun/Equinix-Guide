class CreateConnectiontypes < ActiveRecord::Migration
  def self.up
    create_table :connectiontypes do |t|
      t.string :name
      t.text :type_description
      t.timestamps
    end
    
    c = Connectiontype.new
    c.id = 2
    c.name = "C"
    c.type_description = "Carrier has multi-customer Access Center or Network Point of Presence (POP) inside facility. No LEC/PTT needed, just cross-connect within facility."
    c.save!
    
    c = Connectiontype.new
    c.id = 3
    c.name = "G"
    c.type_description = "Extranet Provider has multi-customer Network Point of Presence (POP) inside facility."
    c.save!
    
    c = Connectiontype.new
    c.id = 4
    c.name = "E"
    c.type_description = "Extranet Provider can terminate circuits inside facility. Commonly referred to as 'Type 2'."
    c.save!
    
    c = Connectiontype.new
    c.id = 5
    c.name = "A"
    c.type_description = "Carrier can terminate circuits inside facility on-net (LIT). Commonly referred to as 'Type 1'."
    c.save!
    
    c = Connectiontype.new
    c.id = 6
    c.name = "B"
    c.type_description = "Carrier can only terminate circuits inside facility off-net (NOT-LIT). Commonly referred to as 'Type 2'."
    c.save!
    
    c = Connectiontype.new
    c.id = 7
    c.name = "D"
    c.type_description = "Carrier is available at facility, but access type unknown."
    c.save!
    
    c = Connectiontype.new
    c.id = 8
    c.name = "F"
    c.type_description = "Extranet Provider is available in the facility, but its access to facility is unknown."
    c.save!
    
    c = Connectiontype.new
    c.id = 9
    c.name = "H"
    c.type_description = "Available via in-building cross-connect OR IBX from another on-campus facility."
    c.save!
    
    c = Connectiontype.new
    c.id = 10
    c.name = "I"
    c.type_description = "Network not available at this facility."
    c.save!
  end

  def self.down
    drop_table :connectiontypes
  end
end
