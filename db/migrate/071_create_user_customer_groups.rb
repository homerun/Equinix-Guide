class CreateUserCustomerGroups < ActiveRecord::Migration
  def self.up
    create_table :user_customer_groups do |t|
      t.integer :user_id, :customer_group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_customer_groups
  end
end