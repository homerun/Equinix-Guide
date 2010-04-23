class AddReportType < ActiveRecord::Migration
  def self.up
    report_type = Reporttype.find_by_page_name('services_and_networkproviders_report')
    report_type.expected_parameters = 'selected_regions,selected_pois,selected_services,selected_datacenter,public_report'
    report_type.save!
    
    report_type = Reporttype.new()
    report_type.controller_name = 'salesinfo'
    report_type.page_name = 'view_prospects_report'
    report_type.expected_parameters = 'public_report,prospect_status_types,selected_regions'
    report_type.type_title = 'Prospects Report'
    report_type.save!
  end
  
  def self.down
    report_type = Reporttype.find_by_page_name('services_and_networkproviders_report')
    report_type.expected_parameters = 'selected_regions,selected_pois,selected_services,selected_datacenter'
    report_type.save!
    
    Reporttype.find_by_page_name('view_prospects_report').destroy
  end
end