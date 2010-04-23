require "pdf/writer"
require "pdf/simpletable"

class NetworkServicesReportController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def index
    @subnav = 'network_services_report'
    @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
    @list_of_networktermpttype_ids = Networktermpttype.find(:all, :order => 'name').collect { |t| [t.name, t.id]}    
    @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    @list_of_ntps = Networkterminationpoint.find(:all, :order => 'name').collect{|ntp| [ntp.name, ntp.id]}
    if !@list_of_ntps.nil? then
      @add_to_ntp_list_size = [[@list_of_ntps.size,15].min,5].max
    end
    session[:selected_ntps] = Array.new
    @list_of_selected_ntps = Array.new
    @remove_from_ntp_list_size = 5
    @first_load = true
  end
  
  def get_ntps
    @list_of_ntps = Networkterminationpoint.find(:all, :conditions => conditions, :order => 'name').collect{|ntp| [ntp.name,ntp.id]} 
    if !@list_of_ntps.nil? then
      @add_to_ntp_list_size = [[@list_of_ntps.size,15].min,5].max
    end
    render :partial => 'ntp_selector'
  end
  
  def add_selected_ntps
    @list_of_selected_ntps = Array.new
    params[:add_ntps].each do |ntp_id|
      session[:selected_ntps] << ntp_id.to_i if !session[:selected_ntps].include?(ntp_id.to_i)
    end
    session[:selected_ntps].each do |ntp_id|
      ntp = Networkterminationpoint.find_by_id(ntp_id)
      @list_of_selected_ntps << [ntp.name,ntp.id] if ntp
    end
    @list_of_selected_ntps.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    @remove_from_ntp_list_size = [[@list_of_selected_ntps.size,15].min,5].max
    render :partial => 'view_list'
  end
  
  def remove_selected_ntps
    @list_of_selected_ntps = Array.new
    params[:remove_ntps].each do |ntp_id|
      session[:selected_ntps].delete_if {|ntp| ntp_id.to_i == ntp}
    end
    session[:selected_ntps].each do |ntp_id|
      ntp = Networkterminationpoint.find_by_id(ntp_id)
      @list_of_selected_ntps << [ntp.name,ntp.id] if ntp
    end 
    @list_of_selected_ntps.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    @remove_from_ntp_list_size = [[@list_of_selected_ntps.size,15].min,5].max
    render :partial => 'view_list'
  end
  
  def select_region
    unless params[:region_id] == 'All'
      subregion_list = Equinixregion.find(params[:region_id]).subregions.collect{|sub| sub.id}
      @list_of_countries = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|c| [c.name,c.id] }
    else  
      @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    end
    render :partial => 'select_country'
  end
  
  def print_network_service_connection_to_ntp(np2ntp_list, ntp)
    np2ntp_list.each do |np2ntp|
      if np2ntp.networkterminationpoint == ntp then
        if ['A','C','D','G'].include?(np2ntp.connectiontype.name) then
          return 'O'
        else
          return 'X'
        end
      end
    end
    return ' '
  end
  
  def view_network_services_report
    @owner = params[:owner]
    if params[:filename].blank? then
      @filename = 'Network Services Report'
    else
      @filename = params[:filename]
    end
    session[:view_mode] = params[:id] unless params[:id].blank?
    @list_of_display_ntps = Networkterminationpoint.find(:all,:conditions => ["id in (:ntps)", {:ntps => session[:selected_ntps]}]).sort {|x,y| x.name.downcase <=> y.name.downcase }
    @network_services = get_network_services
    render(:partial => 'print_network_services_pane', :layout => false, :locals => {:printable => true}) and return if session[:view_mode] == 'print'
    if session[:view_mode] == 'csv' then
      csv_file = ''
      csv_file += "Network Provider,Website,#{(@list_of_display_ntps.collect {|ntp| ntp.name}).join(',')}\n"
      @network_services.each do |network_service|
        csv_file += "#{network_service[0].name},#{network_service[0].url},"
        csv_file += "#{(@list_of_display_ntps.collect {|ntp| print_network_service_connection_to_ntp(network_service[1],ntp)}).join(',')}\n"
      end
      send_data(csv_file, :type => 'text/csv', :filename => "#{ @filename.gsub(/[\/:*?”<>'|"]/,'_') }.csv" )
    elsif session[:view_mode] == 'pdf' then
      send_pdf
    end
  end
  
  def send_pdf
        
    #report_pdf = PDF::Writer.new(:paper => [27.94,35.56])
    report_pdf = PDF::Writer.new(:orientation => :landscape)
    old_left_margin = report_pdf.left_margin
    old_top_margin = report_pdf.top_margin
    report_pdf.left_margin = 0
    report_pdf.top_margin = 0
    report_pdf.select_font "Times-Roman"
    report_pdf.stroke_color Color::RGB::Black
    report_pdf.rectangle(0,report_pdf.page_height-45,report_pdf.page_width,45).fill
    report_pdf.fill_color Color::RGB::Red
    report_pdf.rectangle(0,report_pdf.page_height-46,report_pdf.page_width,1).fill
    y_position = report_pdf.y + 0
    report_pdf.add_image_from_file("http://www.circuitclout.com/images/Equinix_GUIDE.png",10,y_position,84,30)
    report_pdf.add_image_from_file("http://www.circuitclout.com/images/equinix_logo.png",report_pdf.page_width-70,y_position+2,55,28)
    
    report_pdf.left_margin = old_left_margin
    report_pdf.top_margin = old_top_margin
    report_pdf.fill_color Color::RGB::Black
    report_pdf.text ' ', :font_size => 10, :justification => :center
    report_pdf.text 'Network Services Report', :font_size => 20, :justification => :center
    
    the_table = PDF::SimpleTable.new
    the_table.font_size = 7
    the_table.maximum_width = report_pdf.page_width - 30
    the_table.position = :center
    the_table.orientation = :center
    the_table.shade_heading_color = Color::RGB::Black
    the_table.shade_headings = true
    the_table.heading_color = Color::RGB::White
    the_table.heading_font_size = 7
    the_table.data = []
    the_table.columns['np'] = PDF::SimpleTable::Column.new('np') { |col| col.heading = 'Network Provider'.upcase }
    the_table.columns['url'] = PDF::SimpleTable::Column.new('url') { |col| col.heading = 'Website'.upcase }
    @list_of_display_ntps.each do |ntp| 
      the_table.columns[ntp.name] = PDF::SimpleTable::Column.new(ntp.name) do |col| 
        col.heading = ntp.name.upcase
        col.justification = :center
      end
    end
    the_table.data = []
    
    in_facility_text = 'font::ZapfDingbats::color::255,0,0::n'
    ibx_text = 'font::ZapfDingbats::color::0,0,0::n'
    
    @network_services.each do |network_service|
      data_row = {'np' => network_service[0].name, 'url' => network_service[0].url}
      @list_of_display_ntps.each do |ntp|
        if print_network_service_connection_to_ntp(network_service[1],ntp) == 'O' then
          data_row[ntp.name] = ibx_text
        elsif print_network_service_connection_to_ntp(network_service[1],ntp) == 'X' then
          data_row[ntp.name] = in_facility_text
        end
      end
      the_table.data << data_row
    end
    
    the_table.column_order = ['np','url']
    @list_of_display_ntps.each {|ntp| the_table.column_order << ntp.name}
    
    
    report_pdf.text ' ', :font_size => 10, :justification => :center unless the_table.data.size == 0
    the_table.render_on(report_pdf) unless the_table.data.size == 0
    report_pdf.text ' ', :font_size => 10, :justification => :center unless the_table.data.size == 0
    report_pdf.text ' = Available in facility', :font_size => 10, :justification => :center unless the_table.data.size == 0
    report_pdf.select_font('ZapfDingbats')
    report_pdf.fill_color(Color::RGB.new(0,0,0))
    report_pdf.add_text((report_pdf.page_width/2)-50,report_pdf.y,'n',8)
    report_pdf.select_font('Times-Roman')
    report_pdf.fill_color(Color::RGB::Black)
    report_pdf.text ' = Available from another IBX', :font_size => 10, :justification => :center unless the_table.data.size == 0
    report_pdf.select_font('ZapfDingbats')
    report_pdf.fill_color(Color::RGB.new(255,0,0))
    report_pdf.add_text((report_pdf.page_width/2)-80,report_pdf.y,'n',8)
    report_pdf.select_font('Times-Roman')
    report_pdf.fill_color(Color::RGB::Black)
    
    send_data report_pdf.render, :filename => "Network-Services-Report.pdf",
              :type => "application/pdf"
  end
  
private 

  def conditions
    conditions = []
    parameters = []
    if params[:search]
      if params[:search][:networktermpttype_id] != "All" 
        conditions << "networktermpttype_id = ?" 
        parameters << params[:search][:networktermpttype_id]
      end
      if params[:search][:networktermptowner_id] != "All" 
        conditions << "networktermptowner_id = ?" 
        parameters << params[:search][:networktermptowner_id]
      end
      if params[:search][:region_id] != "All" 
        subregion_list = Equinixregion.find(params[:search][:region_id]).subregions.collect{|sub| sub.id}
        country_list = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})").collect{|c| c.id}
        conditions << "country_id in (#{country_list.join(',')})" 
      end
      if params[:search][:country_id] != "All" 
        conditions << "country_id = ?" 
        parameters << params[:search][:country_id]
      end
    end
    [conditions.join(" AND "), *parameters]
  end
  
  def get_network_services
    network_services_list = Hash.new
    return nil if @list_of_display_ntps == nil
    @list_of_display_ntps.each do |ntp|
      ntp.np_connections.each do |np_connection|
        network_services_list[np_connection.networkprovider] = Array.new if network_services_list[np_connection.networkprovider] == nil
        network_services_list[np_connection.networkprovider] << np_connection
      end
    end
    network_services_array = Array.new
    network_services_list.each_pair do |np,np_connection_list|
      network_services_array << [np,np_connection_list]
    end
    network_services_array.sort {|x,y| x[0].name.downcase <=> y[0].name.downcase}
  end
end
