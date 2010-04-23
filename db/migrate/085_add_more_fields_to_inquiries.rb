class AddMoreFieldsToInquiries < ActiveRecord::Migration
  def self.up
    add_column :inquiries, :inquire_to_email, :string
    add_column :inquiries, :inquire_to_name, :string
    add_column :inquiries, :inquire_to_user, :integer
  end
  
  def self.down
    remove_column :inquiries, :inquire_to_email
    remove_column :inquiries, :inquire_to_name
    remove_column :inquiries, :inquire_to_user
  end
end