class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    r = Role.new
    r.name = "Super User"
    r.description = "Full Access. All pages, all actions."
    r.save!
    
    r = Role.new
    r.name = "Administrator"
    r.description = "Access to User Accounts. View and Edit Data."
    r.save!
    

    r = Role.new
    r.name = "Editor"
    r.description = "Access to View and Edit Data."
    r.save!
    
    r = Role.new
    r.name = "Subscriber"
    r.description = "Access to View Data and Save Reports."
    r.save!
  end

  def self.down
    drop_table :roles
  end
end
