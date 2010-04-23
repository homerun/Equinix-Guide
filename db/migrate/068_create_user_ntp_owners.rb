class CreateUserNtpOwners < ActiveRecord::Migration
  def self.up
    create_table :user_ntp_owners do |t|
      t.integer :user_id, :networktermptowner_id
      t.timestamps
    end
    
    un = UserNtpOwner.new
    un.user_id = User.find_by_email("superuser@homerunoffices.com").id
    un.networktermptowner_id = Networktermptowner.find_by_name("Equinix").id
    un.save!
    
    un = UserNtpOwner.new
    un.user_id = User.find_by_email("administrator@homerunoffices.com").id
    un.networktermptowner_id = Networktermptowner.find_by_name("Equinix").id
    un.save!
    
    un = UserNtpOwner.new
    un.user_id = User.find_by_email("editor@homerunoffices.com").id
    un.networktermptowner_id = Networktermptowner.find_by_name("Equinix").id
    un.save!
    
    un = UserNtpOwner.new
    un.user_id = User.find_by_email("subscriber@homerunoffices.com").id
    un.networktermptowner_id = Networktermptowner.find_by_name("Equinix").id
    un.save!
  end

  def self.down
    drop_table :user_ntp_owners
  end
end 
