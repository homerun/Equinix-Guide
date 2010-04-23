class CreatePoi2poiowners < ActiveRecord::Migration
  def self.up
    create_table :poi2poiowners do |t|
      t.integer :pointsofinterest_id, :poiowner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :poi2poiowners
  end
end
