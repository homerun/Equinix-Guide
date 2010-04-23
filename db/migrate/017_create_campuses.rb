class CreateCampuses < ActiveRecord::Migration
  def self.up
    Inflector.inflections do |inflect|
      inflect.irregular 'campus', 'campuses'
    end
    
    create_table :campuses do |t|
      t.integer :connectiontype_id, :default => Connectiontype.find_by_name("H").id
      t.integer :networktermptowner_id, :user_contact
      t.string :name, :url
      t.timestamps
    end
    
    c = Campus.new
    c.networktermptowner_id = Networktermptowner.find_by_name("Equinix").id
    c.name = "Equinix (New York)"
    c.connectiontype_id = Connectiontype.find_by_name("H").id
    c.save!
    
    c = Campus.new
    c.networktermptowner_id = Networktermptowner.find_by_name("Equinix").id
    c.name = "Equinix (Chicago)"
    c.connectiontype_id = Connectiontype.find_by_name("H").id
    c.save!
  end

  def self.down
    drop_table :campuses
  end
end
