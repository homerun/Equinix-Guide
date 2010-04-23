class ModifyConnectiontypes < ActiveRecord::Migration
  
  def self.up
    add_column :connectiontypes, :not_a_connection, :boolean
    
    no_connection = Connectiontype.find_by_name('I')
    no_connection.not_a_connection = true
    no_connection.save!
  end

  def self.down
    remove_column :connectiontypes, :not_a_connection
  end

end