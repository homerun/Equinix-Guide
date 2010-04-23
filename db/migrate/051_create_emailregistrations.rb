class CreateEmailregistrations < ActiveRecord::Migration
  def self.up
    create_table :emailregistrations do |t|
      t.integer :user_id, :operating_user_id
      t.string :email_id
      t.boolean :reset, :default => false
      t.boolean :used, :default => false
      t.datetime :expiration_date
      t.timestamps
    end
  end

  def self.down
    drop_table :emailregistrations
  end
end
