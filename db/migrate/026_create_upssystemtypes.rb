class CreateUpssystemtypes < ActiveRecord::Migration
  def self.up
    create_table :upssystemtypes do |t|
      t.string :ups_system_type
      t.timestamps
    end
    
    type = Upssystemtype.new
    type.ups_system_type = "Chloride, Static"
    type.save!

  end

  def self.down
    drop_table :upssystemtypes
  end
end
