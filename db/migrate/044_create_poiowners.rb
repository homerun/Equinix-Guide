class CreatePoiowners < ActiveRecord::Migration
  def self.up
    create_table :poiowners do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :poiowners
  end
end
