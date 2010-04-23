class CreateCustomerGroups < ActiveRecord::Migration
  def self.up
    create_table :customer_groups do |t|
      t.text :name, :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :customer_groups
  end
end