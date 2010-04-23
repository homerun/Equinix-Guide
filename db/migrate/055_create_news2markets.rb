class CreateNews2markets < ActiveRecord::Migration
  def self.up
    create_table :news2markets do |t|
      t.integer :market_id, :newsitem_id
      t.timestamps
    end
  end

  def self.down
    drop_table :news2markets
  end
end
