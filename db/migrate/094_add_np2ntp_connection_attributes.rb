class AddNp2ntpConnectionAttributes < ActiveRecord::Migration
  
  def self.up
    add_column :np2ntps, :available, :string, :size => 1
    add_column :np2ntps, :connection_type, :string, :size => 1
    add_column :np2ntps, :multiple_access, :string, :size => 1
    add_column :np2ntps, :owned, :string, :size => 1
    add_column :np2ntps, :owner_networkprovider_id, :integer
    
    add_column :contestlist_np2ntps, :available, :string, :size => 1
    add_column :contestlist_np2ntps, :connection_type, :string, :size => 1
    add_column :contestlist_np2ntps, :multiple_access, :string, :size => 1
    add_column :contestlist_np2ntps, :owned, :string, :size => 1
    add_column :contestlist_np2ntps, :owner_networkprovider_id, :integer
    
    create_table :connection_service_descriptions do |t|
      t.string :description, :abbreviation
    end
    
    create_table :connection_services do |t|
      t.integer :np2ntp_id, :connection_service_description_id
    end
    
    ["Lit Fiber","Dark Fiber","Internet"].each do |descr|
      connection_service = ConnectionServiceDescription.new
      connection_service.description = descr
      connection_service.save!
    end
  end

  def self.down
    remove_column :np2ntps, :available
    remove_column :np2ntps, :connection_type
    remove_column :np2ntps, :multiple_access
    remove_column :np2ntps, :owned
    remove_column :np2ntps, :owner_networkprovider_id
    
    remove_column :contestlist_np2ntps, :available
    remove_column :contestlist_np2ntps, :connection_type
    remove_column :contestlist_np2ntps, :multiple_access
    remove_column :contestlist_np2ntps, :owned
    remove_column :contestlist_np2ntps, :owner_networkprovider_id
    
    drop_table :connection_service_descriptions
    drop_table :connection_services
  end

end