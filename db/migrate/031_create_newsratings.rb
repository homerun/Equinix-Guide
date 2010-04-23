class CreateNewsratings < ActiveRecord::Migration
  def self.up
    create_table :newsratings do |t|
      t.integer :newsitem_id, :user_id
      t.boolean :rating
      t.timestamps
    end
  end

  def self.down
    drop_table :newsratings
  end
end
