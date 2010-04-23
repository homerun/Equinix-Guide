class AddCampusAccessTypes < ActiveRecord::Migration
  
  def self.up
    create_table :campus_access_types do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :campus_ntp2ntps do |t|
      t.integer :a_networkterminationpoint_id, :b_networkterminationpoint_id, :campus_access_type_id, :campus_id
      t.decimal :latency_time, { :precision => 12, :scale => 7 }
    end
    
    access_type = CampusAccessType.new
    access_type.name = 'IBX Link'
    access_type.save!
    access_type = CampusAccessType.new
    access_type.name = 'Cross-Connect'
    access_type.save!

    label = Tablefieldlabel.new
    label.table_name = 'Networkterminationpoint'
    label.field_name = 'campus_access_type_id'
    label.label = 'Campus Access Type'
    label.look_up_table = 'CampusAccessType'
    label.look_up_field = 'name'
    label.description = 'Campus Access Type'
    label.save!
  end

  def self.down 
=begin
    begin
      drop_table :campus_access_types
      drop_table :campus_ntp2ntps
      
      access_type = CampusAccessType.find_by_name("Type 1")
      access_type.destroy! unless access_type.nil?
      access_type = CampusAccessType.find_by_name("Type 2")
      access_type.destroy! unless access_type.nil?
      access_type = CampusAccessType.find_by_name("Type 3")
      access_type.destroy! unless access_type.nil?
      access_type = CampusAccessType.find_by_name("Unknown")
      access_type.destroy! unless access_type.nil?
      
      label = Tablefieldlabel.find_by_field("campus_access_type_id")
      label.destroy! unless label.nil?
    rescue
      
  end
=end
#=begin
    begin
      drop_table :campus_access_types
      remove_column :networkterminationpoints, :campus_access_type_id
      
      access_type = CampusAccessType.find_by_name("In main facility")
      access_type.destroy! unless access_type.nil?
      access_type = CampusAccessType.find_by_name("Nearby facility")
      access_type.destroy! unless access_type.nil?
      access_type = CampusAccessType.find_by_name("IBX connection")
      access_type.destroy! unless access_type.nil?
      access_type = CampusAccessType.find_by_name("Unknown")
      access_type.destroy! unless access_type.nil?
      
      label = Tablefieldlabel.find_by_field("campus_access_type_id")
      label.destroy! unless label.nil?
    rescue
      
    end
#=end
  end

end