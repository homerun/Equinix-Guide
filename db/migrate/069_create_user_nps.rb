class CreateUserNps < ActiveRecord::Migration
  def self.up
    create_table :user_nps do |t|
      t.integer :user_id, :networkprovider_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_nps
  end
end
