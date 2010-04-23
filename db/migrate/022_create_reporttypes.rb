class CreateReporttypes < ActiveRecord::Migration
  def self.up
    create_table :reporttypes do |t|
      t.string :controller_name, :page_name, :expected_parameters, :type_title
      t.timestamps
    end
    
    r = Reporttype.new
    r.controller_name = "salesinfo"
    r.page_name = "services_and_networkproviders_report"
    r.expected_parameters = "selected_regions,selected_pois,selected_services,selected_datacenter"
    r.type_title = "Data Center to Exchanges Network Report"
    r.save!
  end

  def self.down
    drop_table :reporttypes
  end
end
