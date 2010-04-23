class ChangeForeignKeys < ActiveRecord::Migration
  def self.up
    rename_column :np2ntps, :user_certified, :user_id
    rename_column :latencytimes, :user_certified, :user_id
    rename_column :np2pois, :user_certified, :user_id
    rename_column :poi2ntps, :user_certified, :user_id
    rename_column :np2ntps, :contest_list, :contest_list_id
  end
  
  def self.down
    rename_column :np2ntps, :user_id, :user_certified
    rename_column :latencytimes, :user_id, :user_certified
    rename_column :np2pois, :user_id, :user_certified
    rename_column :poi2ntps, :user_id, :user_certified
    rename_column :np2ntps, :contest_list_id, :contest_list
  end
end      