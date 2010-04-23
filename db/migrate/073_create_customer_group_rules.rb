class CreateCustomerGroupRules < ActiveRecord::Migration
  def self.up
    create_table :customer_group_rules do |t|
      t.integer :customer_group_id
      t.text :page_name, :id_list
      t.boolean :all_pages
      t.timestamps
    end
  end

  def self.down
    drop_table :customer_group_rules
  end
end