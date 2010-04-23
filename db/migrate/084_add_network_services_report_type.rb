class AddNetworkServicesReportType < ActiveRecord::Migration
  def self.up
    report_type = Reporttype.new()
    report_type.controller_name = 'network_services_report'
    report_type.page_name = 'view_network_services_report'
    report_type.expected_parameters = 'selected_ntps,view_mode'
    report_type.type_title = 'Network Services Report'
    report_type.save!
  end
  
  def self.down
    Reporttype.find_by_page_name('network_services_report').destroy
  end
end