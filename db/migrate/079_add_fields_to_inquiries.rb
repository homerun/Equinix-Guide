class AddFieldsToInquiries < ActiveRecord::Migration
  def self.up
    add_column :inquiries, :sent_at, :datetime
    add_column :inquiries, :inquiry_table, :string
    add_column :inquiries, :inquire_to_table, :string
    add_column :inquiries, :inquiry_table_id, :integer
    add_column :inquiries, :inquire_to_table_id, :integer
  end  
  
  def self.down
    remove_column :inquiries, :sent_at
    remove_column :inquiries, :inquiry_table
    remove_column :inquiries, :inquire_to_table
    remove_column :inquiries, :inquiry_table_id
    remove_column :inquiries, :inquire_to_table_id
  end
end    