class CreateAudittrails < ActiveRecord::Migration
  def self.up
    create_table :audittrails do |t|
      t.integer :user_id, :transaction_id, :table_id
      t.string :field_name, :action, :old_value, :new_value, :table_name
      t.boolean :action
      t.timestamps
    end
  end

  def self.down
    drop_table :audittrails
  end
end
