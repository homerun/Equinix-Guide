class CreateNewsitems < ActiveRecord::Migration
  def self.up
    create_table :newsitems do |t|
      t.integer :user_id
      t.string :title, :url, :tags
      t.text  :descr
      t.datetime :article_date
      t.timestamps
    end
  end

  def self.down
    drop_table :newsitems
  end
end
