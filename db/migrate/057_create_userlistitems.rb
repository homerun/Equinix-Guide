class CreateUserlistitems < ActiveRecord::Migration
  def self.up
    create_table :userlistitems do |t|
      t.integer :user_id, :userlist_id
      t.timestamps
    end
  end

  def self.down
    drop_table :userlistitems
  end
end
