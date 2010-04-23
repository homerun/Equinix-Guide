class CreatePoiaccountnotes < ActiveRecord::Migration
  def self.up
    create_table :poiaccountnotes do |t|
      t.integer :pointsofinterest_id, :user_id
      t.text :note
      t.datetime :date_time
      t.timestamps
    end
  end

  def self.down
    drop_table :poiaccountnotes
  end
end
