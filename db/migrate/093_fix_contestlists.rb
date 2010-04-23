class FixContestlists < ActiveRecord::Migration
  
  def self.up
    add_column :contestlist_poi2ntps, :user_id, :integer
    add_column :contestlist_poi2ntps, :poiconnectiontype_id, :integer
    remove_column :contestlist_poi2ntps, :field_name
    remove_column :contestlist_poi2ntps, :connection_table
    
    add_column :contestlist_np2ntps, :user_id, :integer
    add_column :contestlist_np2ntps, :connectiontype_id, :integer
    remove_column :contestlist_np2ntps, :field_name
    remove_column :contestlist_np2ntps, :connection_table
  end

  def self.down
    remove_column :contestlist_poi2ntps, :user_id
    remove_column :contestlist_poi2ntps, :poiconnectiontype_id
    add_column :contestlist_poi2ntps, :field_name, :string
    add_column :contestlist_poi2ntps, :connection_table, :string
    
    remove_column :contestlist_np2ntps, :user_id
    remove_column :contestlist_np2ntps, :connectiontype_id
    add_column :contestlist_np2ntps, :field_name, :string
    add_column :contestlist_np2ntps, :connection_table, :string
  end

end