class UpdateTableLabels < ActiveRecord::Migration
  def self.up    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntpprospectnote"
    tablefieldlabel.field_name = "note"
    tablefieldlabel.description = "Note"
    tablefieldlabel.label = "Note"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntpprospect"
    tablefieldlabel.field_name = "pointsofinterest_id"
    tablefieldlabel.description = "Point of Interest"
    tablefieldlabel.label = "Point of Interest"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntpprospect"
    tablefieldlabel.field_name = "networkterminationpoint_id"
    tablefieldlabel.description = "Network Termination Point"
    tablefieldlabel.label = "Network Termination Point"
    tablefieldlabel.look_up_table = "Networkterminationpoint"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntpprospect"
    tablefieldlabel.field_name = "prospectstatustype_id"
    tablefieldlabel.description = "Prospect Status"
    tablefieldlabel.label = "Status"
    tablefieldlabel.look_up_table = "Prospectstatustype"
    tablefieldlabel.look_up_field = "status_description"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntpprospect"
    tablefieldlabel.field_name = "poiconnectiontype_id"
    tablefieldlabel.description = "Connection Type"
    tablefieldlabel.label = "Connection Type"
    tablefieldlabel.look_up_table = "Poiconnectiontype"
    tablefieldlabel.look_up_field = "description"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poiaccountexecutive"
    tablefieldlabel.field_name = "user_id"
    tablefieldlabel.description = "User"
    tablefieldlabel.label = "User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poiaccountexecutive"
    tablefieldlabel.field_name = "country_id"
    tablefieldlabel.description = "Country"
    tablefieldlabel.label = "Country"
    tablefieldlabel.look_up_table = "Country"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poiaccountnote"
    tablefieldlabel.field_name = "note"
    tablefieldlabel.description = "Note"
    tablefieldlabel.label = "Note"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    campus_labels = Tablefieldlabel.find(:all,:conditions => ["table_name = 'Campuses'"]);
    campus_labels.each do |campus_label|
      campus_label.table_name = 'Campus'
      campus_label.save!
    end
    
    campus_labels = Tablelabel.find(:all,:conditions => ["table_name = 'Campuses'"]);
    campus_labels.each do |campus_label|
      campus_label.table_name = 'Campus'
      campus_label.save!
    end
    
    (1..4).each do |i|
      network_contact_label = Tablefieldlabel.find(:first,:conditions => ["table_name = 'Networkprovider' and field_name = 'userContactRegion#{i}'"])
      if network_contact_label then
        network_contact_label.field_name = "user_contact_region#{i}"
        network_contact_label.save!
      end
    end
    
    country = Country.find_by_id(248)
    country.name = "Aland Islands"
    country.save!
  end

  def self.down
    table_field_labels_to_drop = [{:table => "Poi2ntpprospectnote",   :fields => ["note"]},
                                  {:table => "Poi2ntpprospect",       :fields => ["pointsofinterest_id","networkterminationpoint_id","prospectstatustype_id","poiconnectiontype_id"]},
                                  {:table => "Poiaccountexecutive",   :fields => ["user_id","country_id"]},
                                  {:table => "Poiaccountnote",        :fields => ["note"]}]
    table_field_labels_to_drop.each do |label_item|
      label_item[:fields].each do |field_name|
        label = Tablefieldlabel.find(:first,:conditions => ["table_name = :table and field_name = :field", {:table => label_item[:table], :field => field_name}])
        Tablefieldlabel.delete(label.id)
      end      
    end                          
  end
end
