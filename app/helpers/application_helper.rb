# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def get_user_menu
    links = ''
    links += "#{create_link('manage_user','add_user','Add User')}<br/>"
    links += "#{create_link('manage_user','unregistered_users','Unregistered Users')}<br/>"
    links += "#{create_link('customer_groups','index','Customer Groups')}"
    links
  end
  
  def get_news_menu
    links = "#{create_link('news','submit_news','Submit News')}<br/>"
    links += "#{create_link('news','view_news','View News')}<br/>"
    links += "#{create_link('feeds','notification_rules','Notifications')}" if @current_user.is_equinix_user?
    links
  end
  
  def get_field_match_units(datacenter_details,field_name)
    user = User.find_by_id(session[:user_id])
    return eval("datacenter_details.#{field_name}_metric") if user.unit_preference == 'M'
    return eval("datacenter_details.#{field_name}_british")
  end
  
  def get_fieldname_match_units(field_name)
    user = User.find_by_id(session[:user_id])
    return "#{field_name}_metric" if user.unit_preference == 'M'
    return "#{field_name}_british"
  end
  
  def get_short_unit_name(unitName,unitClass = nil)
    if unitClass == nil then
      user = User.find_by_id(session[:user_id])
      unitClass = user.unit_preference
    end
    if unitClass == 'M' then
      return 'm' if unitName == 'length' or unitName == 'distance'
      return 'L' if unitName == 'volume'
      return 'm<sup>2</sup>' if unitName == 'area'
      return "&deg;C" if unitName == 'temperature'
    else
      return 'ft' if unitName == 'length'
      return 'gal' if unitName == 'volume'
      return 'yrds' if unitName == 'distance'
      return 'ft<sup>2</sup>' if unitName == 'area'
      return "&deg;F" if unitName == 'temperature'
    end
    return 'N/A'
  end
  
  def get_long_unit_name(unitName,unitClass = nil)
    if unitClass == nil then
      user = User.find_by_id(session[:user_id])
      unitClass = user.unit_preference
    end
    if unitClass == 'm' or unitClass == 'M' then
      return 'meters' if unitName == 'length' or unitName == 'distance'
      return 'litres' if unitName == 'volume'
      return 'meters<sup>2</sup>' if unitName == 'area'
      return '&deg;Celsius' if unitName == 'temperature'
    else
      return 'feet' if unitName == 'length'
      return 'yards' if unitName == 'distance'
      return 'gallons' if unitName == 'volume'
      return 'feet<sup>2</sup>' if unitName == 'area'
      return '&deg;Farhenheit' if unitName == 'temperature'
    end
    return 'N/A'
  end
  
  def print_yes(field)
    return 'Yes' if field == true
    return 'No' if field == false
    return 'Provided @ sign in' if field == 'P'
  end
  
  def get_reports_menu
    user = User.find_by_id(session[:user_id])
    links = ''
    links += "#{create_link('salesinfo','select_region','Data Center to Exchanges Network Report')}<br/>" if user != nil and (user.is_equinix_user?)
    links += "#{create_link('salesinfo','competitive_market_report_options','Competitive Market Report')}<br/>" if user.is_equinix_user?
    links += "#{create_link('salesinfo','prospects_report_report_options','Prospects Report')}<br/>" if user.is_equinix_user?
    links += "#{create_link('reports','index','Saved Reports')}"
  end
  
  def get_manage_menu
    links = ''
    links += "#{create_link('manage','edit_region','Equinix Regions')}<br/>" if @current_user.can_view_page?('edit_region')
    links += "#{create_link('pointsofinterests','edit','Points of Interest')}<br/>" if @current_user.can_view_page?('edit_poi')
    links += "#{create_link('networkterminationpoints','edit','Network Termination Points')}<br/>" if @current_user.can_view_page?('edit_ntp')
    links += "#{create_link('manage','edit_ntp_owner','Network Termination Point Owners')}<br/>" if @current_user.can_view_page?('edit_ntp_owner')
    links += "#{create_link('manage','edit_networkprovider','Network Providers')}<br/>" if @current_user.can_view_page?('edit_networkprovider')
    links += "#{create_link('manage','edit_latency_time','Latency Times')}<br/>" if @current_user.can_view_page?('edit_latency_time')
    links += "#{create_link('manage','edit_market','Competitive Markets')}<br/>" if @current_user.can_view_page?('edit_market')
    links += "#{create_link('manage','edit_campus','Campuses')}<br/>" if @current_user.can_view_page?('edit_campus')
    links += "#{create_link('manage','account_executive_management','My Accounts')}" if @current_user.can_view_page?('account_executive_management')
    links
  end
  
  def get_view_menu
    links = ''
    links += "#{create_link('salesinfo','view_regions','Equinix Regions')}<br/>"
    links += "#{create_link('salesinfo','view_pois','Points of Interest')}<br/>"
    links += "#{create_link('salesinfo','view_ntps','Network Termination Points')}<br/>"
    links += "#{create_link('salesinfo','view_network_services','Network Services')}<br/>"
    links += "#{create_link('salesinfo','poi_hosting_scorecard','Scorecard')}"
    return links
  end
  
  def print_addr_summary(ntp)
    returnString = ''
    returnString += ntp.city + ', ' if ntp.city != nil
    returnString += ntp.state_or_province + ', ' if ntp.state_or_province != nil
    returnString += ntp.country if ntp.country != nil 
  end
  
  def create_link_old (controller, page, text)
    if session[:page] == page
      return  "#{text}"
    else
      return "#{ link_to(text, { :controller => controller, :action => page}, :onclick => "return confirmed();" ) }";
    end
  end
  
  def create_link(controller, page, text)
    if request.request_uri.index("/#{controller}/#{page}") != nil
      return  "#{text}"
    else
      return "#{ link_to(text, { :controller => controller, :action => page}, :onclick => "return confirmed();" ) }";
    end
  end
  
  def userLoggedIn?
    return session[:user_id] != nil
  end
  
  
  def generate_info_div(connectionType)
    "<div style=\"position: relative; display: inline;\" onmouseover=\"javascript:show_type_descr(this,'#{connectionType.name} - #{connectionType.type_description}');\">#{connectionType.name}</div>"
  end
  
  
  def print_full_addr(ntp)
    returnString = ''
    returnString += ntp.street_address
    returnString += "<br/>Floor: #{ntp.floor}" if ntp.floor != nil and !ntp.floor.blank?
    returnString += "<br/>Suite: #{ntp.suite}" if ntp.suite != nil and !ntp.suite.blank?
    returnString += "<br/>#{ntp.city}" if ntp.city != nil and !ntp.city.blank?
    returnString += ", #{ntp.state_or_province}" if ntp.state_or_province != nil and !ntp.state_or_province.blank?
    returnString += " #{ntp.zip_code}" if ntp.zip_code != nil and !ntp.zip_code.blank?
    returnString += "<br/>#{ntp.country.name}" unless ntp.country.nil?
    returnString
  end
 
  def print_field_type(page,table)
    page_and_table_to_field_type = {
      'edit_ntp' => {'Np2ntp' => 'Network Provider Connection', 'Poi2ntp' => 'Point of Interest connection', 'Networkterminationpoint' => 'Network Termination Point Attribute'},
      'edit_np' => {'Np2ntp' => 'Network Termination Point Connection', 'Networkprovider' => 'Network Provider Attribute'},
      'edit_poi' => {'Poi2ntp' => 'Network Termination Point Connection', 'Poipreferrednp' => 'Network Provider Connection', 'Pointsofinterest' => 'Point of Interest Attribute'}}
    return "Unknown #{page}-#{table}" if page_and_table_to_field_type[page] == nil
    return "Unknown #{page}-#{table}" if page_and_table_to_field_type[page][table] == nil
    return page_and_table_to_field_type[page][table]
  end
  
  def print_name_with_association_from_id(user_id,table = nil,table_id = nil)
    association = ''
    user = User.find_by_id(user_id)
    if !user.networkproviders.nil?  
      association = " (#{user.networkproviders.collect{|p| p.name}.join(',')})"
    elsif !user.networktermptowners.nil? 
      association = " (#{user.networktermptowners.collect{|p| p.name}.join(',')})"
    elsif !user.pointsofinterests.nil?
      association = " (#{user.pointsofinterests.collect{|p| p.name}.join(',')})"
    end
    return "#{user.print_name}#{association}"
  end
  
  def print_association_from_id(user_id,table = nil,table_id = nil)
    return "deprecated function 'print_association_from_id' in application_helper.rb"
  end
  
  def has_admin_role
    user = User.find_by_id(session[:user_id])
    return false if user == nil
    return true if user.role_id == 1 or user.role_id == 2
    return false
  end

  def has_editor_role
    user = User.find_by_id(session[:user_id])
    return false if user == nil
    return true if user.role_id == 1 or user.role_id == 2 or user.role_id == 3
    return false
  end
 
  def user_is_contact_only?
    user = User.find_by_id(session[:user_id])
    return true if user == nil
    return true if user.role_id == 5
    return false
  end
  
  def me?(user)
    return if user == nil
    return user.id == session[:user_id] if user.instance_of?(User)
    return user == session[:user_id]
  end
  
  def me
    return session[:user_id]
  end
 
  def print_message_div(div_id,text,msg=nil)
    if msg.nil? then
      msg = text
      text = div_id
      div_id = 'connectionTypeDescr'
    end
    "<div style=\"position: relative; display: inline;\" onmouseover='javascript:show_message(\"#{div_id}\",this,\"#{msg}\");'>#{text}</div>"
  end
  
  def get_unit_preference
    user = User.find_by_id(session[:user_id])
    return user.unit_preference
  end
  
  def current_user_id
    return session[:user_id]
  end
  
  def print_date(dt)
    return dt.strftime('%m/%d/%Y') unless dt.nil?
    return ""
  end
  
  def get_news_ids_from_tags(tags)
    newsitem_ids = Array.new
    tags.split(',').each do |tag|
      tag_obj = Othertag.find_by_tag(tag.strip)
      newsitem_ids += tag_obj.newsitems.collect {|newsitem| newsitem.id } if tag_obj != nil
    end
    newsitem_ids.uniq!
    return newsitem_ids.join(',')
  end
  
  
  def is_extranet_provider(user = nil)
    user = User.find_by_id(session[:user_id]) if user == nil
    return false if user.associationTable != 'Networkprovider'
    user.associationTableId.split(',').each do |networkprovider_id|
      np = Networkprovider.find_by_id(networkprovider_id)
      return true if np != nil and np.extranet_type == true
    end
    return false
  end
  
  def current_page
    return session[:page]
  end
  
  def escapeKML(str)
    str.gsub(/&/,'&amp;')
  end
  
  def duration_in_words(time1,time2)
    diff = (time1 - time2).to_i
    return pluralize(diff,'second') if diff < 60
    diff = (diff / 60).to_i
    return pluralize(diff,'minute') if diff < 60
    diff = (diff / 60).to_i
    return pluralize(diff,'hour')
  end
  
  private
 
  
  
  def get_main_report_menu_deprecated
    if session[:page] == 'select_regions'
      return 'Selecting Region...'
    elsif session[:page] == 'select_pois'
      return "#{ create_link('salesinfo','select_region','Select Regions') }<br/>Selecting Points of Interest..."
    elsif session[:page] == 'select_services'
      return "#{ create_link('salesinfo','select_region','Select Regions') }<br/>#{ create_link('salesinfo','select_points_of_interest','Select Points of Interest') }<br/>Selecting Services..."
    elsif session[:page] == 'select_datacenter'
      return "#{ create_link('salesinfo','select_region','Select Regions') }<br/>#{ create_link('salesinfo','select_points_of_interest','Select Points of Interest') }<br/>#{ create_link('salesinfo','select_services','Select Services') }<br/>Selecting Datacenter..."
    elsif session[:page] == 'view_report'
      return "#{ create_link('salesinfo','select_region','Select Regions') }<br/>#{ create_link('salesinfo','select_points_of_interest','Select Points of Interest') }<br/>#{ create_link('salesinfo','select_services','Select Services') }<br/>#{ create_link('salesinfo','select_datacenter','Select Datacenter') }<br/>View Report"
    else
      return "#{ create_link('salesinfo','select_region','Select Regions') }"
    end
  end
end
