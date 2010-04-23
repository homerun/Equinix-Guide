class CreateNews2regions < ActiveRecord::Migration
  def self.up
    create_table :news2regions do |t|
      t.integer :equinixregion_id, :newsitem_id
      t.timestamps
    end
  end

  def self.down
    drop_table :news2regions
  end
end
