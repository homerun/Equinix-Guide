class MergeProspectsToPoi2ntp < ActiveRecord::Migration
  def self.up
    add_column :poi2ntps, :prospectstatustype_id, :integer, :null => false, :default => 1
    add_column :poi2ntps, :public, :boolean, :null => false, :default => true
    
    prospects = Poi2ntpprospect.find(:all)
    prospects.each do |prospect|
      ntp_connection = Poi2ntp.find(:first,:conditions => ["pointsofinterest_id = :poi_id and networkterminationpoint_id = :ntp_id and poiconnectiontype_id = :type_id", {:poi_id => prospect.pointsofinterest_id, :ntp_id => prospect.networkterminationpoint_id, :type_id => prospect.poiconnectiontype_id}])
      if ntp_connection.nil? then
        new_ntp_connection = Poi2ntp.new()
        new_ntp_connection.pointsofinterest_id = prospect.pointsofinterest_id
        new_ntp_connection.networkterminationpoint_id = prospect.networkterminationpoint_id
        new_ntp_connection.poiconnectiontype_id = prospect.poiconnectiontype_id
        new_ntp_connection.prospectstatustype_id = prospect.prospectstatustype_id
        new_ntp_connection.save!
        prospect.notes.each do |note|
          note.update_attribute(:poi2ntpprospect_id, new_ntp_connection.id)
        end if !prospect.notes.nil?
        #Poi2ntpprospect.delete(prospect.id)
      end
    end if prospects != nil
    
    rename_column :poi2ntpprospectnotes, :poi2ntpprospect_id, :poi2ntp_id
    
    rename_table :poi2ntpprospectnotes, :poi2ntpnotes
    
    drop_table :poi2ntpprospects 
  end

  def self.down

    create_table :poi2ntpprospects do |t|
      t.integer :pointsofinterest_id, :networkterminationpoint_id, :prospectstatustype_id, :poiconnectiontype_id
      t.timestamps
    end
    
    ntp_connections = Poi2ntp.find(:all,:conditions => "prospectstatustype_id <> 1")
    ntp_connections.each do |ntp_connection|
      prospect = Poi2ntpprospect.find(:first,:conditions => ["pointsofinterest_id = :poi_id and networkterminationpoint_id = :ntp_id and poiconnectiontype_id = :type_id", {:poi_id => ntp_connection.pointsofinterest_id, :ntp_id => ntp_connection.networkterminationpoint_id, :type_id => ntp_connection.poiconnectiontype_id}])
      if prospect.nil? then
        new_prospect = Poi2ntpprospect.new()
        new_prospect.pointsofinterest_id = ntp_connection.pointsofinterest_id
        new_prospect.networkterminationpoint_id = ntp_connection.networkterminationpoint_id
        new_prospect.poiconnectiontype_id = ntp_connection.poiconnectiontype_id
        new_prospect.prospectstatustype_id = ntp_connection.prospectstatustype_id
        new_prospect.save!
        ntp_connection.notes.each do |note|
          note.update_attribute(:poi2ntp_id, new_prospect.id)
        end if !ntp_connection.notes.nil?
      end
      Poi2ntp.delete(ntp_connection.id)
    end if ntp_connections != nil
    
    rename_column :poi2ntpnotes, :poi2ntp_id, :poi2ntpprospect_id
    
    rename_table :poi2ntpnotes, :poi2ntpprospectnotes 
    
    remove_column :poi2ntps, :prospectstatustype_id
    remove_column :poi2ntps, :public
  end
end