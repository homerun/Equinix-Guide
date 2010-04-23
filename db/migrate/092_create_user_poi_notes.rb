class CreateUserPoiNotes < ActiveRecord::Migration
  
  def self.up
    create_table :user_poi_notes do |t|
      t.integer :user_poi_id
      t.integer :user_id
      t.string :note
      t.datetime :date_time
    end
  end

  def self.down
    drop_table :user_poi_notes
  end

end