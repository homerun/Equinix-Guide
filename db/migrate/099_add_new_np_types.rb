class AddNewNpTypes < ActiveRecord::Migration
  
  def self.up
    
    add_column :networkproviders, :carrier_type, :boolean
    add_column :networkproviders, :extranet_type, :boolean
    add_column :networkproviders, :isp_type, :boolean
    add_column :networkproviders, :routing_type, :boolean
    
    label = Tablefieldlabel.new
    label.table_name = 'Networkprovider'
    label.field_name = 'carrier_type'
    label.label = 'Carrier'
    label.look_up_table = 'Hash'
    label.look_up_field = "{'0' => 'No', '1' => 'Yes'}"
    label.description = 'Carrier (Network Provider Type)'
    label.save!
    
    label = Tablefieldlabel.new
    label.table_name = 'Networkprovider'
    label.field_name = 'extranet_type'
    label.label = 'Extranet'
    label.look_up_table = 'Hash'
    label.look_up_field = "{'0' => 'No', '1' => 'Yes'}"
    label.description = 'Extranet (Network Provider Type)'
    label.save!
    
    label = Tablefieldlabel.new
    label.table_name = 'Networkprovider'
    label.field_name = 'isp_type'
    label.label = 'ISP'
    label.look_up_table = 'Hash'
    label.look_up_field = "{'0' => 'No', '1' => 'Yes'}"
    label.description = 'ISP (Network Provider Type)'
    label.save!
    
    label = Tablefieldlabel.new
    label.table_name = 'Networkprovider'
    label.field_name = 'routing_type'
    label.label = 'Optimized IP Routing'
    label.look_up_table = 'Hash'
    label.look_up_field = "{'0' => 'No', '1' => 'Yes'}"
    label.description = 'Optimized IP Routing (Network Provider Type)'
    label.save!
    
    Networkprovider.find(:all).each do |networkprovider|
      networkprovider.carrier_type = (networkprovider.np_type == 'C')
      networkprovider.extranet_type = (networkprovider.np_type == 'E')
      networkprovider.isp_type = false
      networkprovider.routing_type = false
      networkprovider.save!
    end
  end

  def self.down 
    
    remove_column :networkproviders, :carrier_type
    remove_column :networkproviders, :extranet_type
    remove_column :networkproviders, :isp_type
    remove_column :networkproviders, :routing_type
  end

end