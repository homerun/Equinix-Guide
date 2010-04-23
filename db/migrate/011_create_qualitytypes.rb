class CreateQualitytypes < ActiveRecord::Migration
  def self.up
    create_table :qualitytypes do |t|
      t.string :quality_type
      t.timestamps
    end
    
    ["Tier I", "Tier II", "Tier III", "Tier III+", "Tier IV"].each do |qt|
      quality_type = Qualitytype.new
      quality_type.quality_type = qt
      quality_type.save!
    end
  end

  def self.down
    drop_table :qualitytypes
  end
end
