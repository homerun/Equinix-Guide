class CreateContestlistitems < ActiveRecord::Migration
  def self.up
    create_table :contestlistitems do |t|
      t.integer :user_id, :connectiontype_id, :contestlist_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contestlistitems
  end
end
