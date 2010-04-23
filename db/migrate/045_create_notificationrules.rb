class CreateNotificationrules < ActiveRecord::Migration
  def self.up
    create_table :notificationrules do |t|
      t.integer :user_id
      t.integer :seq_num, :l_paren, :r_paren
      t.string :object_name, :field_name, :comparison_operator, :and_or
      t.boolean :get_news, :default => false
      t.boolean :get_additions, :default => false
      t.boolean :get_updates, :default => false
      t.text :comparison_value
      t.datetime :start_date
      t.timestamps
    end
  end

  def self.down
    drop_table :notificationrules
  end
end
