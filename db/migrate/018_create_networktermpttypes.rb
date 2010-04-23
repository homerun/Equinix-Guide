class CreateNetworktermpttypes < ActiveRecord::Migration
  def self.up
    create_table :networktermpttypes do |t|
      t.string :name
      t.timestamps
    end
    
    ["Datacenter", "Exchange", "Other"].each do |t|
      type = Networktermpttype.new
      type.name = t
      type.save!
    end
  end

  def self.down
    drop_table :networktermpttypes
  end
end
