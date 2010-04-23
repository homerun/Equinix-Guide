class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name, :last_name, :email, :phone_number, :hashed_password, :salt
      t.string :unit_preference, :default => 'M'
      t.integer :role_id#, :association_table_id
      t.string :active, :default => 'R'
      t.boolean :default_user, :default => false
      t.timestamps
    end
    
    if(User.find_by_email("superuser@homerunoffices.com").nil?)
      admin = User.new
      admin.email = 'superuser@homerunoffices.com'
      admin.first_name = 'Equinix'
      admin.last_name = 'Super User'
      admin.password = 'Equinix'
      admin.role_id = Role.find_by_name("Super User").id
      admin.default_user = true
      admin.active = 'Y'
      admin.save!
    end  
    
    if(User.find_by_email("administrator@homerunoffices.com").nil?)
      admin = User.new
      admin.email = 'administrator@homerunoffices.com'
      admin.first_name = 'Equinix'
      admin.last_name = 'Administrator'
      admin.password = 'Equinix'
      admin.role_id = Role.find_by_name("Administrator").id
      admin.default_user = true
      admin.active = 'Y'
      admin.save!
    end
    
    if(User.find_by_email("editor@homerunoffices.com").nil?)
      admin = User.new
      admin.email = 'editor@homerunoffices.com'
      admin.first_name = 'Equinix'
      admin.last_name = 'Editor'
      admin.password = 'Equinix'
      admin.role_id = Role.find_by_name("Editor").id
      admin.default_user = true
      admin.active = 'Y'
      admin.save!
    end
    
    if(User.find_by_email("subscriber@homerunoffices.com").nil?)
      admin = User.new
      admin.email = 'subscriber@homerunoffices.com'
      admin.first_name = 'Equinix'
      admin.last_name = 'Subscriber'
      admin.password = 'Equinix'
      admin.role_id = Role.find_by_name("Subscriber").id
      admin.default_user = true
      admin.active = 'Y'
      admin.save!
    end
  end

  def self.down
    drop_table :users
  end
end