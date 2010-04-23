class CreateNews2pois < ActiveRecord::Migration
  def self.up
    create_table :news2pois do |t|
      t.integer :pointsofinterest_id, :newsitem_id
      t.timestamps
    end
  end

  def self.down
    drop_table :news2pois
  end
end
