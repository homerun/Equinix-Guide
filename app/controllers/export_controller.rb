class ExportController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def services_and_networkproviders_report
    headers['Content-Type'] = "application/vn.ms-excel"
    if params[:filename] == nil then
      headers['Content-Disposition'] = 'attachment; filename="circuitclout_generated_report.xls"'
    else
      headers['Content-Disposition'] = "attachment; filename=\"#{params[:filename]}.xls\""
    end
    headers['Cache-Control'] = ''
    @row_count = 5
    @regions_present = Hash.new
    @services_list = Hash.new
    session[:selected_services].each do |serviceId|
      service = Service.find_by_id(serviceId)
      @services_list[service.poi] = Array.new if @services_list[service.poi] == nil
      @services_list[service.poi] << service
    end if session[:selected_services] != nil
    session[:selected_pois].each do |pointsofinterest_id|
      poi = Pointsofinterest.find_by_id(pointsofinterest_id)
      @services_list[poi] = [] if @services_list[poi] == nil 
    end if session[:selected_pois] != nil
    @poi_list = Array.new
    @services_list.each_pair do |pointsofinterest_id, services|
      poi = Pointsofinterest.find_by_id(pointsofinterest_id)
      @regions_present[poi.subregion.equinixregion.id] = true 
      locations = poi.ntp_connections.collect { |ntp_connection| [ntp_connection,ntp_connection.networkterminationpoint] }
      @poi_list << [poi.subregion.equinixregion.region_name,poi,locations,services]
      @row_count += locations.size
      @row_count += 1 if locations.size == 0
    end
    @poi_list.sort! {|x,y| "#{x[0]} #{x[1].name}" <=> "#{y[0]} #{y[1].name}"}
    @datacenter = Networkterminationpoint.find_by_id(session[:selected_datacenter])
    @regions_present[@datacenter.parentcountry.subregion.equinixregion.id] = true
    @networkproviders = Array.new
    @datacenter.np_connections.each do |np_connection|
      @networkproviders.insert(0,np_connection.networkprovider) if np_connects_to_poi_in_list(np_connection.networkprovider,@poi_list)
    end
    @contact_rows = 0
    @regions_present.each_pair {|key,value| @contact_rows += 1 }
    @row_count += @contact_rows
    @networkproviders.sort! { |x,y| x.name.downcase <=> y.name.downcase }
    render :partial => 'services_and_networkproviders_report'
  end
  
  def to_excel
    headers['Content-Type'] = "application/vn.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="new_report.xls"'
    headers['Cache-Control'] = ''
    render :partial => 'services_and_networkproviders_report'
  end
  
  
  def np_connects_to_poi_in_list(np,poi_obj_list)
    poi_obj_list.each do |poi_obj|
      poi_obj[2].each do |ntp_obj|
        ntp_obj[1].np_connections.each do |np_connection|
          return true if np_connection.networkprovider == np
        end if ntp_obj[1].np_connections != nil
      end if poi_obj[2] != nil
    end
    return false
  end
  
end
