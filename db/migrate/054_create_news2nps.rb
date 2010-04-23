class CreateNews2nps < ActiveRecord::Migration
  def self.up
    create_table :news2nps do |t|
      t.integer :networkprovider_id, :newsitem_id
      t.timestamps
    end
  end

  def self.down
    drop_table :news2nps
  end
end
