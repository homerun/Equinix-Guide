class CreateNews2ntpowners < ActiveRecord::Migration
  def self.up
    create_table :news2ntpowners do |t|
      t.integer :networktermptowner_id, :newsitem_id 
      t.timestamps
    end
  end

  def self.down
    drop_table :news2ntpowners
  end
end
