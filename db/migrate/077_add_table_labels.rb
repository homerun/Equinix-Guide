class AddTableLabels < ActiveRecord::Migration
  def self.up
    
    tablefieldlabel = Tablefieldlabel.find(:first,:conditions => "table_name = 'Poiaccountnote' and field_name = 'note'")
    tablefieldlabel.description = "Account Note"
    tablefieldlabel.label = "Account Note"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find(:first,:conditions => "table_name = 'Networkterminationpoint' and field_name = 'campus_id'")
    tablefieldlabel.look_up_table = "Campus"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntpnote"
    tablefieldlabel.field_name = "note"
    tablefieldlabel.description = "Prospect Note"
    tablefieldlabel.label = "Prospect Note"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
  end

  def self.down
    
    Tablefieldlabel.find_by_table_name_and_field_name('Poi2ntpnote','note').destroy
    
  end
end
