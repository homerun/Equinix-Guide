class CreateProspectstatustypes < ActiveRecord::Migration
  def self.up
    create_table :prospectstatustypes do |t|
      t.string :status_description
      t.timestamps
    end
    
    ["Live", "Signed but not yet live", "Pipeline", "Targeted"].each do |t|
      type = Prospectstatustype.new
      type.status_description = t
      type.save!
    end
  end

  def self.down
    drop_table :prospectstatustypes
  end
end
