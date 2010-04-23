module SalesinfoHelper
  
  def count_pois(region)
    count = 0
    region.subregions.each do |subregion|
      subregion.pois.each do |poi|
        count += 1
      end
    end
    count
  end
  
  
  def get_all_pois(region)
    pois = Array.new
    region.subregions.each do |subregion|
      subregion.pois.each do |poi|
        pois << poi
      end
    end
    pois.sort { |x,y| x.name <=> y.name }
  end
  
  
  def np_connects_to_poi(np,poi)
    get_np2poi_connection(np,poi) == nil
  end
  
  def get_np2poi_connection(np,poi)
    np.poi_connections.each do |poi_connection|
        return poi_connection if poi_connection.poi == poi
    end
    return nil
  end
  
  
  def print_link_to_np2poi_connection_type(np,poi)
    connection = get_np2poi_connection(np,poi)
    return 'NO' if connection == nil
    id = connection.id
    types = print_np2poi_connection_types(np,poi,'<br/>')
    "<b>YES</b><br/><div onmouseout='$(\"type#{id}\").innerHTML = \"More Details\"' onmouseover='javascript:$(\"type#{id}\").innerHTML = \"#{types}\"' id='type#{id}'>More Details</a>"
  end
  
  
  def np_connect_to_service?(np,srvc)
    np.poi_connections.each do |poi_connection|
      poi_connection.services.each do |service|
        return true if srvc == service
      end
    end
    return false
  end
  
  
  def np_in_equinix_dc?(np)
    np.dc_connections.each do |dc_connection|
      return true if dc_connection.datacenter.datacentercompany.company == "Equinix"
    end
    return false
  end
  
  
  def np_can_indirect_connect?(np)
    np.dc_connections.each do |dc_connection| 
      return true if dc_connection.connectionType == "Equinix"
    end
    return false
  end
  
  
  def print_np2ntp_connection_types(np,dc,separator)
    connection = Np2ntp.find(:first, :conditions => ["networkprovider_id = :networkprovider_id and networkterminationpoint_id = :networkterminationpoint_id", {:networkprovider_id => np.id, :networkterminationpoint_id => dc.id}])
    return '<br/>' if connection.connectiontype == nil
    connection.details
    #connection.type_connection.types.collect { |type| type.type_description }).join(separator)
  end
  
  
  def print_np2poi_connection_types(np,poi,separator)
    connection = Np2poi.find(:first, :conditions => ["networkprovider_id = :networkprovider_id and pointsofinterest_id = :pointsofinterest_id", {:networkprovider_id => np.id, :pointsofinterest_id => poi.id}])
    return 'None' if connection.connectiontype == nil
    connection.details
    #connection.type_connection.types.collect { |type| type.type_description }).join(separator)
  end
  
  
  def connection_type_descr_div(connectionType)
    "<div style=\"position: relative; display: inline;\" onmouseover=\"javascript:show_type_descr(this,'#{connectionType.name} - #{connectionType.type_description}');\">#{connectionType.name}</div>"
  end
  
  
  def poi_connection_type_descr_div(connectionType)
    "<div style=\"position: relative; display: inline;\" onmouseover=\"javascript:show_type_descr(this,'#{connectionType.name} - #{connectionType.description}');\">#{connectionType.name}</div>"
  end
  
  
  def print_np2poi_connection_info(np,poi,ntp,data)
    return 'No' if data[np] == nil
    return 'No' if data[np][poi] == nil
    return 'No' if data[np][poi][ntp.id] == nil or data[np][poi][ntp.id] == 'No'
    "<b>YES</b> #{(data[np][poi][ntp.id].collect {|latency_time| "(#{latency_time.latency_ime}ms #{connection_type_descr_div(latency_time.np2ntpA.connectiontype)} & #{connection_type_descr_div(latency_time.np2ntpB.connectiontype)})"}).join(' ')}"
  end
  
  
  def get_page_navigation
    if session[:page] == 'select_regions'
      return 'Selecting Region...'
    elsif session[:page] == 'select_pois'
      return "#{ link_to 'Select Regions', :action => :select_region } > Selecting Points of Interest..."
    elsif session[:page] == 'select_services'
      return "#{ link_to 'Select Regions', :action => :select_region } > #{ link_to 'Select Points of Interest', :action => :select_points_of_interest } > Selecting Services..."
    elsif session[:page] == 'select_datacenter'
      return "#{ link_to 'Select Regions', :action => :select_region } > #{ link_to 'Select Points of Interest', :action => :select_points_of_interest } > #{ link_to 'Select Services', :action => :select_services } > Selecting Datacenter..."
    else
      return "#{ link_to 'Select Regions', :action => :select_region } > #{ link_to 'Select Points of Interest', :action => :select_points_of_interest } > #{ link_to 'Select Services', :action => :select_services } > #{ link_to 'Select Datacenter', :action => :select_datacenter } > View Report"
    end
  end
  
  
  def print_dc_addr_summary(datacenter)
    returnString = ''
    returnString += datacenter.city + ', ' if datacenter.city != nil and !datacenter.city.blank?
    returnString += datacenter.state_or_province + ', ' if datacenter.state_or_province != nil and !datacenter.state_or_province.blank?
    returnString += datacenter.country if datacenter.country != nil and !datacenter.country.blank?
  end
  
  
  def print_latency_time(np,datacenter,poi_ntp)
    np2ntpDatacenter = Np2ntp.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and networkterminationpoint_id = :networkterminationpoint_id", {:networkprovider_id => np.id, :networkterminationpoint_id => datacenter.id}])
    return "<b>NO</b>" if np2ntpDatacenter.details["not available"] != nil and np2ntpDatacenter.user != nil
    return "NO" if np2ntpDatacenter.details["not available"] != nil
    np2ntpPoi = Np2ntp.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and networkterminationpoint_id = :networkterminationpoint_id", {:networkprovider_id => np.id, :networkterminationpoint_id => poi_ntp.id}])
    return "" if np2ntpDatacenter == nil or np2ntpPoi == nil
    latency_time = Latencytime.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and a_np2ntp_id = :np2ntpA and b_np2ntp_id = :np2ntpB", 
                                                          {:networkprovider_id => np.id, 
                                                           :np2ntpA => [np2ntpDatacenter.id,np2ntpPoi.id].min(), 
                                                           :np2ntpB => [np2ntpDatacenter.id,np2ntpPoi.id].max() }])
    yes_or_no = "#{((np2ntpPoi.connectiontype.not_a_connection)?('NO'):('YES'))}"
    return "<b>#{yes_or_no}</b><br/>#{np2ntpPoi.details}" if latency_time == nil and np2ntpDatacenter.user != nil and np2ntpPoi.user != nil
    return "#{yes_or_no}<br/>#{np2ntpPoi.details}" if latency_time == nil
    return "<b>#{yes_or_no}</b><br/>#{np2ntpPoi.details}<br/><span class=\"latency_time\">#{latency_time.latency_time} ms</span>" if np2ntpDatacenter.user != nil and np2ntpPoi.user != nil
    return "#{yes_or_no}<br/>#{np2ntpPoi.details}<br/><span class=\"latency_time\">#{latency_time.latency_time} ms</span>"
  end
  
  
  def get_miles_distance(ntpSelf, ntpOther)
    if ntpOther.lat == nil or ntpOther.lon == nil or ntpSelf.lat == nil or ntpSelf.lon == nil or ntpSelf == ntpOther then
      return ''
    end
    other_lat = ntpOther.lat.to_f
    other_lon = ntpOther.lon.to_f
    self_lat = ntpSelf.lat.to_f
    self_lon = ntpSelf.lon.to_f
    to_rads = Math::PI / 180.0
    begin
      d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    rescue
      return ''
    end
    "#{((d * 100).round.to_f / 100)} km / #{(d * 62.1371192).round.to_f / 100} miles"
  end
  
  
  def get_preferred_distance(ntpSelf, ntpOther)
    if ntpOther.lat == nil or ntpOther.lon == nil or ntpSelf.lat == nil or ntpSelf.lon == nil or ntpSelf == ntpOther then
      return ''
    end
    other_lat = ntpOther.lat.to_f
    other_lon = ntpOther.lon.to_f
    self_lat = ntpSelf.lat.to_f
    self_lon = ntpSelf.lon.to_f
    to_rads = Math::PI / 180.0
    begin
      d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    rescue
      return ''
    end
    if @current_user.unit_preference == 'B' then
      "#{((d * 100).round.to_f / 100)} km"
    else
      "#{(d * 62.1371192).round.to_f / 100} miles"
    end
  end
  
  
  def get_distance_with_theoretical_latency(ntpSelf, ntpOther)
    if ntpOther.lat == nil or ntpOther.lon == nil or ntpSelf.lat == nil or ntpSelf.lon == nil or ntpSelf == ntpOther then
      return ''
    end
    other_lat = ntpOther.lat.to_f
    other_lon = ntpOther.lon.to_f
    self_lat = ntpSelf.lat.to_f
    self_lon = ntpSelf.lon.to_f
    to_rads = Math::PI / 180.0
    begin
      d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    rescue
      return ''
    end
    "#{((d * 100).round.to_f / 100)} km<br/>#{(d * 62.1371192).round.to_f / 100} miles<br/>#{((d*2)/0.0299792458).round.to_f / 10000} ms"
  end
  
  
  def print_poi_region_totals_with_div(poi_ntp_list)
    return "0" if poi_ntp_list == nil or poi_ntp_list.size == 0
    message = (poi_ntp_list.collect {|connection| "Point of Interest: <a href=%%/pointsofinterests/edit/#{connection.pointsofinterest.id}%%>#{connection.pointsofinterest.name.strip}</a> (Datacenter: <a href=%%/networkterminationpoints/edit/#{connection.networkterminationpoint.id}%%>#{connection.networkterminationpoint.name}</a>)"}).join('<br/>')
    "<div style=\"position: relative; display: inline;\" onmouseover='javascript:show_type_descr(this,\"#{message}\");'>#{poi_ntp_list.size}</div>"
  end
  
  def print_poi_hosting_details(poi_ntp_list,div_id)
    return "0" if poi_ntp_list == nil or poi_ntp_list.size == 0
    poi_ntp_list.sort! {|x,y| x.pointsofinterest.name.downcase <=> y.pointsofinterest.name.downcase}
    message = (poi_ntp_list.collect {|connection| "Point of Interest: <a href=%%/pointsofinterests/edit/#{connection.pointsofinterest.id}%%>#{connection.pointsofinterest.name.strip}</a> (Datacenter: <a href=%%/networkterminationpoints/edit/#{connection.networkterminationpoint.id}%%>#{connection.networkterminationpoint.name}</a>)"}).join('<br/>')
    "<div style=\"position: relative; display: inline;\" onmouseover='javascript:show_message(\"#{div_id}\",this,\"#{message}\");'>#{poi_ntp_list.size}</div>"
  end
  
  
  def get_google_map_datacenter_info(ntp)
    info = "<h1>#{ntp.name}</h1>"
    info += "<b>Address:</b><br/>#{ntp.print_full_addr}<br/>"
    if ntp.datacenterdetail != nil then
      info += "<br/><b>Quality Type:</b> #{ntp.datacenterdetail.quality_type.quality_type if ntp.datacenterdetail.quality_type != nil}"
      info += "<br/><b>Floor Size:</b> #{get_field_match_units(ntp.datacenterdetail,'floor_capacity')}"
      info += "<br/><b>Available Space:</b> #{(get_field_match_units(ntp.datacenterdetail,'floor_capacity')*(1 - (ntp.datacenterdetail.occupancy_rate/100.0))).round if ntp.datacenterdetail.occupancy_rate != nil and get_field_match_units(ntp.datacenterdetail,'floor_capacity') != nil}<br/>"
    end
    info += "<br/><b>Financial Exchanges:</b><ul>" + (ntp.poi_connections.collect {|poi_connection| "<li>#{poi_connection.poi.name.strip}</li>"}).join + '</ul>'
    info += "<br/><b>Network Providers:</b>#{get_grouped_list_of_np2ntps(ntp)}"
    return info
  end
  
  def datacenter_building_tab(datacenter)
    ntp = datacenter.networkterminationpoint
    info = "<h1>#{ntp.name}</h1>"
    info += "<br/><b>Address:</b><br/>#{ntp.print_full_addr}<br/>"
    info += "<br/><b>Quality Type:</b> #{datacenter.quality_type.quality_type if datacenter.quality_type != nil}"
    info += "<br/><b>Floor Size:</b> #{get_field_match_units(datacenter,'floor_capacity')} #{get_long_unit_name('area') if !get_field_match_units(datacenter,'floor_capacity').blank?}"
    info += "<br/><b>Available Space:</b> #{(get_field_match_units(datacenter,'floor_capacity')*(1 - (datacenter.occupancy_rate/100.0))).round if !datacenter.occupancy_rate.blank? and !get_field_match_units(datacenter,'floor_capacity').blank?} #{get_long_unit_name('area') if !datacenter.occupancy_rate.blank? and !get_field_match_units(datacenter,'floor_capacity').blank?}<br/>"
    return info
  end
  
  def datacenter_exchanges_tab(datacenter)
    ntp = datacenter.networkterminationpoint
    info = "<h1>#{ntp.name}</h1>"
    info += "<br/><b>Financial Exchanges:</b><ul>" + (ntp.poi_connections.collect {|poi_connection| "<li>#{poi_connection.poi.name.strip}</li>"}).join + '</ul>'
    return info
  end
  
  def datacenter_providers_tab(datacenter)
    ntp = datacenter.networkterminationpoint
    info = "<h1>#{ntp.name}</h1>"
    info += "#{get_grouped_list_of_np2ntps(ntp,true)}"
    return info
  end
  
  def get_grouped_list_of_np2ntps(ntp,is_google_maps=false)
    typeHash = Hash.new
    ntp.np_connections.collect do |np_connection| 
      typeHash[np_connection.details] = Array.new if typeHash[np_connection.details] == nil 
      typeHash[np_connection.details] << np_connection.networkprovider.name unless np_connection.networkprovider.nil?
    end
    if typeHash.size == 0 then
      return '<br/>'
    else
      listString = ''
    end
    typeHash.each_pair do |key, value|
      if is_google_maps then
        listString += "<br/><b>#{key}</b><ul>"
      else
        listString += "<br/>#{key}<ul>"
      end
      listString += (value.collect {|np| "<li>#{np}</li>"}).join
      listString += '</ul>'
    end
    listString
  end
  
  def get_prospects_in_region_market(prospect_list,region_market)
    return_prospects = Array.new
    prospect_list.each do |prospect|
      if region_market[:market]
        return_prospects << prospect if prospect.networkterminationpoint.datacenterdetail && prospect.networkterminationpoint.datacenterdetail.market_id == region_market[:market].id
      else
        return_prospects << prospect if prospect.networkterminationpoint.country_id == region_market[:country].id && prospect.networkterminationpoint.datacenterdetail && prospect.networkterminationpoint.datacenterdetail.market.nil?
      end
    end
    return return_prospects
  end
  
  def routing_text(network_provider)
    if network_provider.routing_type == true then
      return "<i><b>Optimized IP Routing</b></i><br/>"
    else
      return ""
    end
  end
end
