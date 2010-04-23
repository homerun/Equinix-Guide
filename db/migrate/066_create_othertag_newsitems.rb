class CreateOthertagNewsitems < ActiveRecord::Migration
  def self.up
    create_table :othertag_newsitems do |t|
      t.integer :othertag_id, :newsitem_id
      t.timestamps
    end
  end

  def self.down
    drop_table :othertag_newsitems
  end
end
