class CreatePoi2ntpprospectnotes < ActiveRecord::Migration
  def self.up
    create_table :poi2ntpprospectnotes do |t|
      t.integer :user_id, :poi2ntpprospect_id
      t.text :note
      t.datetime :date_time
      t.timestamps
    end
  end

  def self.down
    drop_table :poi2ntpprospectnotes
  end
end
