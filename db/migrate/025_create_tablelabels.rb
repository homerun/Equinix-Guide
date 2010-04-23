class CreateTablelabels < ActiveRecord::Migration
  def self.up
    create_table :tablelabels do |t|
      t.string :table_name, :label, :plural, :look_up_field
      t.timestamps
    end
    
    l = Tablelabel.new
    l.table_name = "Campuses"
    l.label = 'Campus'
    l.plural = 'Campuses'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = "Contestlist"
    l.label = 'Contesting User List'
    l.plural = 'Contesting User Lists'
    l.look_up_field = 'contest_list_name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = "Datacenterdetail"
    l.label = 'Datacenter Details'
    l.plural = 'Datacenter Details'
    l.look_up_field = 'identifier'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Equinixregion'
    l.label = 'Equinix Region'
    l.plural = 'Equinix Regions'
    l.look_up_field = 'region_name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Inquiry'
    l.label = 'Inquiry'
    l.plural = 'Inquiries'
    l.look_up_field = ''
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Country'
    l.label = 'Country'
    l.plural = 'Countries'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Latencytime'
    l.label = 'Latency Time'
    l.plural = 'Latency Times'
    l.look_up_field = ''
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Market'
    l.label = 'Competitive Market'
    l.plural = 'Competitive Markets'
    l.look_up_field = 'market_name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Networkprovider'
    l.label = 'Network Provider'
    l.plural = 'Network Providers'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Networkterminationpoint'
    l.label = 'Network Termination Point'
    l.plural = 'Network Termination Points'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Networktermptowner'
    l.label = 'Network Termination Point Owner'
    l.plural = 'Network Termination Point Owners'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Networktermpttype'
    l.label = 'Network Termination Point Type'
    l.plural = 'Network Termination Point Types'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Np2ntp'
    l.label = 'Network Connection'
    l.plural = 'Network Connections'
    l.look_up_field = 'identifier'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Poi2ntp'
    l.label = 'Point of Interest Connection'
    l.plural = 'Point of Interest Connections'
    l.look_up_field = 'identifier'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Pointsofinterest'
    l.label = 'Point of Interest'
    l.plural = 'Points of Interest'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Poipreferrednp'
    l.label = 'Preferred Network Provider'
    l.plural = 'Preferred Network Providers'
    l.look_up_field = 'identifier'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Service'
    l.label = 'Service'
    l.plural = 'Services'
    l.look_up_field = 'name'
    l.save!
    
    l = Tablelabel.new
    l.table_name = 'Newsitem'
    l.label = 'News'
    l.plural = 'News'
    l.look_up_field = 'title'
    l.save!
  end

  def self.down
    drop_table :tablelabels
  end
end
