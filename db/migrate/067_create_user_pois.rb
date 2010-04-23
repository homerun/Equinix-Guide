class CreateUserPois < ActiveRecord::Migration
  def self.up
    create_table :user_pois do |t|
      t.integer :user_id, :pointsofinterest_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_pois
  end
end
