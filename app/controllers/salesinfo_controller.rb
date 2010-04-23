require "pdf/writer"
require "pdf/simpletable"

class SalesinfoController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
   
  def home
    session[:original_uri] = request.request_uri
    session[:page] = 'home'
  end
  
  def index
    session[:page] = 'home'
  end
  
  def select_regions
    session[:selected_regions] = params[:region_ids]
    @selected_region = session[:selected_regions]
    @selector_size = 5
    session[:selected_countries] = '-1'
    session[:selected_poi] = '-1'
    session[:selected_service] = '-1'
    session[:selected_subregions] = '-1'
    if session[:page] == 'view_ntps' then
      @list_of_countries = get_list_of_countries
      if session[:selected_prox_ntp] != nil and opt_list_contains_id(get_list_of_ntp_options,session[:selected_prox_ntp]) then
        @selected_ntps = [session[:selected_prox_ntp]]
      else
        @selected_ntps = ['-1']
        session[:selected_prox_ntp] = nil
      end
      @update_child = true
      render(:partial => 'country_selector', :layout => false)
    else # if session[:page] == 'view_network_services' then
      @list_of_countries = get_list_of_countries
      @selected_ntps = ['-1']
      @update_child = true
      render(:partial => 'country_selector', :layout => false)
    end
  end
  
  def select_countries
    session[:selected_countries] = params[:country_ids]
    @selected_countries = session[:selected_countries]
    @selector_size = 5
    @page = session[:page]
    if session[:page] == 'view_ntps' then
      @list_of_ntps = get_list_of_ntp_options
      if session[:selected_prox_ntp] != nil and opt_list_contains_id(@list_of_ntps,session[:selected_prox_ntp]) then
        @selected_ntp = [session[:selected_prox_ntp]]
      else
        @selected_ntp = ['-1']
        session[:selected_prox_ntp] = nil
      end
      @update_child = true
      render(:partial => 'ntp_selector', :layout => false)
    else #if session[:page] == 'view_network_services' then
      @list_of_ntps = get_list_of_ntp_options.insert(0,['All','-1'])
      session[:selected_ntps] = session[:selected_ntps].delete_if {|x| !opt_list_contains_id(@list_of_ntps,x)} if session[:selected_ntps] != nil
      @selected_ntps = session[:selected_ntps]
      @update_child = true
      render(:partial => 'ntp_selector', :layout => false)
    end
  end
  
  def select_ntps
    @page = session[:page]
    if session[:page] == 'view_network_services' then
      @list_of_display_ntps = Array.new
      session[:selected_ntps] = params[:ntp_ids]
      @selected_ntps = session[:selected_ntps]
      @selector_size = 5
      if session[:selected_ntps] != nil then
        if session[:selected_ntps].include?('-1') then
          @list_of_display_ntps = get_list_of_ntps
        else
          @list_of_display_ntps = Networkterminationpoint.find(:all,:conditions => ["id in (:ntps)", {:ntps => session[:selected_ntps]}]).sort {|x,y| x.name.downcase <=> y.name.downcase }
        end
        @list_of_display_ntps.sort! {|x,y| x.name.downcase <=> y.name.downcase }
        @network_services = get_network_services
      end
      @update_child = true 
      render(:partial => 'view_network_services_pane', :layout => false) and return
    else # session[:page] == 'view_ntps' then
      @networkterminationpoints = get_list_of_ntps
      if params[:ntp_ids] == nil or params[:ntp_ids].blank? or params[:ntp_ids].include?('-1') then
        if session[:selected_prox_ntp] == nil or session[:selected_prox_ntp] == '-1' or (params[:ntp_ids] != nil and params[:ntp_ids].include?('-1')) then
          @networkterminationpoints.sort! { |x,y| x.name.downcase <=> y.name.downcase }
        else
          if obj_list_contains_id(@networkterminationpoints,session[:selected_prox_ntp]) then
            @base_ntp = Networkterminationpoint.find_by_id(session[:selected_prox_ntp])
            @networkterminationpoints.sort! { |x,y| ((x==@base_ntp)?-1:get_miles_distance(x,@base_ntp)) <=> ((y==@base_ntp)?-1:get_miles_distance(y,@base_ntp)) }
          else
            @networkterminationpoints.sort! { |x,y| x.name.downcase <=> y.name.downcase }
          end
        end
      else
        session[:selected_prox_ntp] = params[:ntp_ids][0]
        @base_ntp = Networkterminationpoint.find_by_id(params[:ntp_ids][0])
        @networkterminationpoints.sort! { |x,y| ((x==@base_ntp)?-1:get_miles_distance(x,@base_ntp)) <=> ((y==@base_ntp)?-1:get_miles_distance(y,@base_ntp)) }
      end
      #@message = "PARAMS: #{params[:ntp_ids]}, SESSION: #{session[:selected_prox_ntp]}, COUNTRIES: #{session[:selected_countries]}, REQUEST: #{request.request_uri}"
      render :partial => 'ntp_list', :layout => false and return
    end
  end
  
  def select_region
    unless @current_user.can_view_page?('services_and_networkproviders_report')
      redirect_to :action => :home
    end
    @subnav = "select_region"
    @regions = Equinixregion.find(:all)
    if request.post?
      session[:selected_regions] = "#{params[:selected_regions]}".split(',')
      redirect_to :action => :select_pois_for_datacenter_to_exchanges_report
    end
    session[:original_uri] = request.request_uri
    session[:page] = 'select_regions'
  end

  def select_points_of_interest
    unless @current_user.can_view_page?('services_and_networkproviders_report')
      redirect_to :action => :home
    end
    if request.post?
      session[:selected_pois] = "#{params[:selected_pois]}".split(',')
      redirect_to :action => :select_services
    else
      @regional_poiss = Array.new 
      session[:selected_regions].each do |regionId|
        region = Equinixregion.find_by_id(regionId)
        @regional_poiss << region
      end
      @regional_poiss.sort! { |x,y| x.region_name.downcase <=> y.region_name.downcase }
      session[:original_uri] = request.request_uri
      session[:page] = 'select_pois'
    end
  end

  def select_pois_for_datacenter_to_exchanges_report
    unless @current_user.can_view_page?('services_and_networkproviders_report')
      redirect_to :action => :home
    end
    if request.post?
      redirect_to :action => :select_services
    else
      @list_of_pois = Pointsofinterest.find(:all, :order => 'name').collect{|poi| [poi.name, poi.id]}
      unless @list_of_pois.nil?
        @add_to_poi_list_size = [[@list_of_pois.size,15].min,5].max
      end
      @list_of_selected_pois = Array.new
      @remove_from_poi_list_size = 5
      @first_load = true
      session[:selected_pois] = []
      session[:original_uri] = request.request_uri
      session[:page] = 'select_pois'
    end
  end
  
  def poi_conditions
    class_where_clause_items = []
    unless @all_classes
      class_where_clause_items << 'pointsofinterests.equities_class = 1' if @equities_class
      class_where_clause_items << 'pointsofinterests.fixed_income_class = 1' if @fixed_income_class
      class_where_clause_items << 'pointsofinterests.foreign_exchange_class = 1' if @foreign_exchange_class
      class_where_clause_items << 'pointsofinterests.futures_class = 1' if @futures_class
    else
      class_where_clause_items << '1=1'
    end
    # provider_categories
    category_string = " and pointsofinterests.poitype_id = 12 and exists (select * from pointsofinterest_provider_categories where pointsofinterest_provider_categories.pointsofinterest_id = pointsofinterests.id and pointsofinterest_provider_categories.pointsofinterest_provider_category_type_id in (#{ @selected_categories.join(',') }))"
    category_string = " and 1=2" if @selected_categories.empty?
    
    return "1=2" if class_where_clause_items.size == 0
    return "#{class_where_clause_items.join(' or ')}" if @selected_regions.size == 0
    return "#{class_where_clause_items.join(' or ')} and unsubregions.equinixregion_id in (#{@selected_regions.join(',')})#{ category_string if @providers_only }" 
  end
  
  def update_poi_search_criteria
    @fixed_income_class = (params[:fixed_income]?true:false)
    @foreign_exchange_class = (params[:foreign_exchange]?true:false)
    @futures_class = (params[:futures]?true:false)
    @equities_class = (params[:equities]?true:false)
    @all_classes = (params[:all_classes]?true:false)
    @selected_regions = params[:selected_regions].collect {|region_id| region_id.to_i }
    @providers_only = (params[:providers_only]?true:false)
    @selected_categories = params[:provider_categories].collect {|category_id| category_id.to_i }
    
    update_select_poi_list
  end
  
  def update_select_poi_list
    @list_of_pois = Pointsofinterest.find(:all, :conditions => poi_conditions, :joins => "LEFT JOIN unsubregions ON unsubregions.id = pointsofinterests.unsubregion_id", :order => 'name').collect{|poi| [poi.name,poi.id]} 
    unless @list_of_pois.nil?
      @add_to_poi_list_size = [[@list_of_pois.size,15].min,5].max
    end
    render :partial => 'select_poi_list'
  end
  
  def add_selected_pois
    @list_of_selected_pois = Array.new
    params[:add_pois].each do |poi_id|
      session[:selected_pois] << poi_id.to_i if !session[:selected_pois].include?(poi_id.to_i)
    end
    session[:selected_pois].each do |poi_id|
      poi = Pointsofinterest.find_by_id(poi_id)
      @list_of_selected_pois << [poi.name,poi.id] if poi
    end
    @list_of_selected_pois.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    @remove_from_poi_list_size = [[@list_of_selected_pois.size,15].min,5].max
    render :partial => 'view_poi_list'
  end
  
  def remove_selected_pois
    @list_of_selected_pois = Array.new
    params[:remove_pois].each do |poi_id|
      session[:selected_pois].delete_if {|poi| poi_id.to_i == poi}
    end
    session[:selected_pois].each do |poi_id|
      poi = Pointsofinterest.find_by_id(poi_id)
      @list_of_selected_pois << [poi.name,poi.id] if poi
    end 
    @list_of_selected_pois.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    @remove_from_poi_list_size = [[@list_of_selected_pois.size,15].min,5].max
    render :partial => 'view_poi_list'
  end

  def select_services
    unless @current_user.can_view_page?('services_and_networkproviders_report')
      redirect_to :action => :home
    end
    if request.post?
      session[:selected_services] = "#{params[:selected_services]}".split(',')
      redirect_to :action => :select_datacenter
    else
      @poi_list = Array.new
      @services = Array.new
      session[:selected_pois].each do |pointsofinterest_id|
        poi = Pointsofinterest.find_by_id(pointsofinterest_id)
        @poi_list << poi.name
        poi.services.each do |service|
          @services << service
        end
      end if session[:selected_pois] != nil
      session[:original_uri] = request.request_uri
      session[:page] = 'select_services'
    end
  end
  
  def select_datacenter 
    unless @current_user.can_view_page?('services_and_networkproviders_report')
      redirect_to :action => :home
    end
    if request.post?
      session[:selected_datacenter] = params[:id] if params[:id] != nil 
      redirect_to :action => :datacenter_to_exchanges_report_options
    else   
      session[:original_uri] = request.request_uri
      ntp_datacenter_type = Networktermpttype.find(:first, :conditions => "name = 'Datacenter'")
      datacenter_hash = Hash.new
      ntp_datacenter_type.networkterminationpoints.each do |ntp|
        if ntp.owner == nil then 
          name = 'No Owner Listed'
        else
          name = ntp.owner.name
        end
        datacenter_hash[name] = Array.new if datacenter_hash[name] == nil
        datacenter_hash[name] << ntp
      end
      @datacenter_objs = Array.new
      datacenter_hash.each_pair do |dc_company, dc_list|
        dc_list.sort! {|x,y| x.name.downcase <=> y.name.downcase }
        @datacenter_objs << {:datacenter_owner => dc_company, :datacenter_list => dc_list}
      end
      @datacenter_objs.sort! {|x,y| (x[:datacenter_owner] == 'Equinix' ? '   AAA' : x[:datacenter_owner].downcase) <=> (y[:datacenter_owner] == 'Equinix' ? '   AAA' : y[:datacenter_owner].downcase)}
    end
  end
  
  def print_network_services_report
    @selected_ntps = session[:selected_ntps]
    if session[:selected_ntps] != nil then
      if session[:selected_ntps].include?('-1') then
        @list_of_display_ntps = Networkterminationpoint.find(:all).sort {|x,y| x.name.downcase <=> y.name.downcase }
      else
        @list_of_display_ntps = Networkterminationpoint.find(:all,:conditions => ["id in (:ntps)", {:ntps => session[:selected_ntps]}]).sort {|x,y| x.name.downcase <=> y.name.downcase }
      end
      @network_services = get_network_services
    end
    render(:partial => 'print_network_services_pane', :layout => false) and return
  end
  
  def datacenter_to_exchanges_report_options
    if request.post?
      session[:public_report] = params[:options][:public]
      session[:num_of_poi_locations] = params[:options][:num_of_poi_locations]
      redirect_to :action => :services_and_networkproviders_report
    else
      #do nothing for now
    end
  end
  
  def prepare_report_vars(params)
    @owner = params[:owner]
    @filename = params[:filename]
    @url_change = "#{ BASE_URL }reports/open_report/#{ (params[:report_id].to_i*9999-321) }?sharable=yes"
  end
  
  

  def services_and_networkproviders_report
    session[:original_uri] = request.request_uri
    session[:page] = 'services_and_networkproviders_report'
    if session[:num_of_poi_locations].nil? or session[:num_of_poi_locations] == 'All' then
      num_of_poi_locations = 'All'
    else
      num_of_poi_locations = session[:num_of_poi_locations].to_i
    end
    prepare_report_vars(params)
    @message = ''
    services_list = Hash.new
    @exchanges_regions_present = Hash.new
    @providers_regions_present = Hash.new
    session[:selected_services].each do |serviceId|
      service = Service.find_by_id(serviceId)
      if service != nil then 
        services_list[service.poi] = Array.new if services_list[service.poi] == nil
        services_list[service.poi] << service if !service.service_acronym.blank?
      end
    end if session[:selected_services] != nil
    @datacenter = Networkterminationpoint.find_by_id(session[:selected_datacenter])
    @exchanges_regions_present[@datacenter.parentcountry.subregion.equinixregion_id] = true if @datacenter.parentcountry
    @providers_regions_present[@datacenter.parentcountry.subregion.equinixregion_id] = true if @datacenter.parentcountry
    session[:selected_pois].each do |pointsofinterest_id|
      poi = Pointsofinterest.find_by_id(pointsofinterest_id)
      services_list[poi] = [] if services_list[poi] == nil
      poi.aggregators.each do |poi_aggregator|
        services_list[poi_aggregator] = [] if services_list[poi_aggregator] == nil and poi_aggregator.poitype.name == "Provider"
      end if poi.aggregators
    end if session[:selected_pois] != nil
    @exchanges_poi_list = Array.new
    @providers_poi_list = Array.new
    services_list.each_pair do |pointsofinterest_id, services|
      poi = Pointsofinterest.find_by_id(pointsofinterest_id)
      if poi.poitype.name == "Provider" then
        @providers_regions_present[poi.subregion.equinixregion.id] = true 
      else
        @exchanges_regions_present[poi.subregion.equinixregion.id] = true 
      end
      locations = Array.new
      poi_in_datacenter = false
      poi.ntp_connections.each do |ntp_connection| 
        if (session[:public_report] == "Yes" and ntp_connection.public) or (session[:public_report] == "No")
          locations << [ntp_connection,ntp_connection.networkterminationpoint]
          if poi.poitype.name == "Provider" then
            poi_in_datacenter = true if (@datacenter.campus != nil and @datacenter.campus.contains_ntp(ntp_connection.networkterminationpoint)) or ntp_connection.networkterminationpoint == @datacenter
            @providers_has_campus_connection = true if (@datacenter.campus != nil and @datacenter.campus.contains_ntp(ntp_connection.networkterminationpoint)) or ntp_connection.networkterminationpoint == @datacenter
          else
            @exchanges_has_campus_connection = true if (@datacenter.campus != nil and @datacenter.campus.contains_ntp(ntp_connection.networkterminationpoint)) or ntp_connection.networkterminationpoint == @datacenter
          end
        end
      end
      @providers_poi_list << [poi.subregion.equinixregion.region_name,poi,locations,services,session[:selected_pois]] if poi_in_datacenter
      locations.sort! {|x,y| get_miles_distance(@datacenter,x[1]) <=> get_miles_distance(@datacenter,y[1])}
      if num_of_poi_locations != 'All' then
        locations = locations[0..(num_of_poi_locations-1)]
      end
      #if poi.poitype.name == "Provider" then
      #  @providers_poi_list << [poi.subregion.equinixregion.region_name,poi,locations,services,session[:selected_pois]]
      #else
      if poi.poitype.name != "Provider" then
        @exchanges_poi_list << [poi.subregion.equinixregion.region_name,poi,locations,services]
      end
    end
    
    # prepare helper variables for exchanges
    @exchanges_poi_list.sort! {|x,y| "#{x[0]} #{x[1].name.downcase}" <=> "#{y[0]} #{y[1].name.downcase}"}
    @exchanges_contact_rows = 0
    @exchanges_regions_present.each_pair {|key,value| @exchanges_contact_rows += 1 }
    @exchanges_networkproviders = Array.new
    @datacenter.np_connections.each do |np_connection|
      @exchanges_networkproviders.insert(0,np_connection.networkprovider) if np_connects_to_poi_in_list(@datacenter.campus,np_connection.networkprovider,@exchanges_poi_list)
    end
    @exchanges_networkproviders.sort! { |x,y| x.name.downcase <=> y.name.downcase }
    
    # prepare helper variables for providers
    @providers_poi_list.sort! {|x,y| "#{x[0]} #{x[1].name.downcase}" <=> "#{y[0]} #{y[1].name.downcase}" }
    @providers_contact_rows = 0
    @providers_regions_present.each_pair {|key,value| @providers_contact_rows += 1 }
=begin
    # This appears to be unused code
    @providers_networkproviders = Array.new
    @datacenter.np_connections.each do |np_connection|
      @providers_networkproviders.insert(0,np_connection.networkprovider) if np_connects_to_poi_in_list(@datacenter.campus,np_connection.networkprovider,@providers_poi_list)
    end
    @providers_networkproviders.sort! { |x,y| x.name.downcase <=> y.name.downcase }
=end
    if params[:printable] then
      render :partial => 'print_datacenter_to_services', :layout => false and return
    end
  end
  
  def view_pois_in_google_earth
    if session[:page] == 'select_pois' then
      session[:selected_pois] = "#{params[:selected_pois]}".split(',')
      kml_file = make_kml_document('Points of Interest',get_kml_styles("\t"), pois_to_placemarks("\t",session[:selected_pois]))
      send_data(kml_file, :type => 'text/kml', :filename => 'Points of Interest.kml')
    elsif session[:page] == 'view_pois' then
      session[:selected_poi2ntps] = "#{params[:selected_poi2ntps]}".split(',')
      kml_file = make_kml_document('Points of Interest',get_kml_styles("\t"), poi2ntps_to_placemarks("\t",session[:selected_poi2ntps]))
      send_data(kml_file, :type => 'text/kml', :filename => 'Points of Interest.kml')      
    else
      session[:selected_ntps] = "#{params[:selected_ntps]}".split(',')
      kml_file = make_kml_document('Network Termination Points',get_kml_styles("\t"), ntps_to_placemarks("\t",session[:selected_ntps]))
      send_data(kml_file, :type => 'text/kml', :filename => 'Network Termination Points.kml')
    end
  end
  
  def view_regions
    @subnav = "view_regions"
    session[:original_uri] = request.request_uri
    session[:page] = 'view_regions'
    @regions = Array.new
    Equinixregion.find(:all).each do |region|
      subregion_count = region.subregions.size
      country_count = 0
      region.subregions.each { |subregion| country_count += subregion.countries.size }
      poi_count = 0
      datacenter_count = 0
      region.subregions.each do |subregion|
        subregion.countries.each do |country| 
          datacenter_count += Networkterminationpoint.find(:all,:conditions => ["country_id = :country_id and networktermpttype_id = 1", {:country_id => country.id}]).size
          poi_count += Networkterminationpoint.find(:all,:conditions => ["country_id = :country_id and networktermpttype_id = 2", {:country_id => country.id}]).size
        end
      end
      @regions << {:id => region.id, :name => region.region_name, :subregions => subregion_count, :countries => country_count, :pois => poi_count, :datacenters => datacenter_count}
    end
  end


  def view_pois
    @subnav = "view_pois"
    session[:original_uri] = request.request_uri
    session[:page] = 'view_pois'
    @regional_poiss = Equinixregion.find(:all)
    @regional_poiss.sort! { |x,y| x.region_name.downcase <=> y.region_name.downcase }
  end


  def view_ntps
    @subnav = "view_ntps"
    session[:original_uri] = request.request_uri
    session[:page] = 'view_ntps'
    @page = session[:page]
    
    @list_of_regions = Equinixregion.find(:all).map { |region| [region.region_name, "#{region.id}"]}
    @list_of_countries = get_list_of_countries
    @list_of_ntps = get_list_of_ntp_options
    
    @selected_ntp = -1
    @selected_regions = session[:selected_regions]
    @selected_countries = session[:selected_countries]
    @networkterminationpoints = get_list_of_ntps
    @networkterminationpoints.sort! { |x,y| x.name.downcase <=> y.name.downcase }
  end


  def update_ntp_list
    @networkterminationpoints = get_list_of_ntps
    if params[:id] == nil or params[:id].blank? or params[:id] == '-1' then
      if params[:id] == '-1' or session[:selected_prox_ntp] == nil or session[:selected_prox_ntp] == '-1' then
        @networkterminationpoints.sort! { |x,y| x.name.downcase <=> y.name.downcase }
      else
        if obj_list_contains_id(@networkterminationpoints,session[:selected_prox_ntp]) then
          @base_ntp = Networkterminationpoint.find_by_id(session[:selected_prox_ntp])
          @networkterminationpoints.sort! { |x,y| ((x==@base_ntp)?-1:get_miles_distance(x,@base_ntp)) <=> ((y==@base_ntp)?-1:get_miles_distance(y,@base_ntp)) }
        else
          @networkterminationpoints.sort! { |x,y| x.name.downcase <=> y.name.downcase }
        end
      end
    else
      session[:selected_prox_ntp] = params[:id]
      @base_ntp = Networkterminationpoint.find_by_id(params[:id])
      @networkterminationpoints.sort! { |x,y| ((x==@base_ntp)?-1:get_miles_distance(x,@base_ntp)) <=> ((y==@base_ntp)?-1:get_miles_distance(y,@base_ntp)) }
    end
    render :partial => 'ntp_list', :layout => false
  end
  
  def poi_hosting_country(update_only=false)
    unless update_only
      @fixed_income_class = (params[:fixed_income] == 'true')?(true):(false)
      @foreign_exchange_class = (params[:foreign_exchange] == 'true')?(true):(false)
      @futures_class = (params[:futures] == 'true')?(true):(false)
      @equities_class = (params[:equities] == 'true')?(true):(false)
      @all_classes = (params[:all_classes] == 'true')?(true):(false)
      @type_1 = (params[:type_1] == 'true')?(true):(false)
      @type_2 = (params[:type_2] == 'true')?(true):(false)
    end
    @selected_region = Equinixregion.find_by_id(params[:region_id]) unless params[:region_id].nil?
    return if @selected_region.nil?
    country_ids = @selected_region.countries.collect {|country| country.id}
    
    @list_of_countries = []
    @list_of_country_datacenter_owners = Array.new
    
    @country_numbers = Hash.new
    DatacenterPoi.find(:all,:conditions => ["country_id in (:country_ids) #{poi_hosting_where_clause}", {:country_ids => country_ids}]).each do |dc_poi|
      @country_numbers[dc_poi.networkterminationpoint.owner] = Hash.new if @country_numbers[dc_poi.networkterminationpoint.owner].nil?
      @list_of_country_datacenter_owners << dc_poi.networkterminationpoint.owner unless @list_of_country_datacenter_owners.include?(dc_poi.networkterminationpoint.owner)
      @list_of_countries << dc_poi.country unless @list_of_countries.include?(dc_poi.country)
      @country_numbers[dc_poi.networkterminationpoint.owner][dc_poi.country] = Array.new if @country_numbers[dc_poi.networkterminationpoint.owner][dc_poi.country].nil?
      @country_numbers[dc_poi.networkterminationpoint.owner][dc_poi.country] << dc_poi.poi2ntp
    end
    @list_of_country_datacenter_owners.sort! {|x,y| ((x.name.downcase=="equinix")?('   Equinix'):(x.name.downcase)) <=> ((y.name.downcase=="equinix")?('   Equinix'):(y.name.downcase))}
    @list_of_countries.sort! {|x,y| x.name.downcase <=> y.name.downcase}
    
    render :partial => 'poi_hosting_country' and return unless update_only
  end
  
  def poi_hosting_market(update_only=false)
    unless update_only
      @fixed_income_class = (params[:fixed_income] == 'true')?(true):(false)
      @foreign_exchange_class = (params[:foreign_exchange] == 'true')?(true):(false)
      @futures_class = (params[:futures] == 'true')?(true):(false)
      @equities_class = (params[:equities] == 'true')?(true):(false)
      @all_classes = (params[:all_classes] == 'true')?(true):(false)
      @type_1 = (params[:type_1] == 'true')?(true):(false)
      @type_2 = (params[:type_2] == 'true')?(true):(false)
    end
    @selected_country = Country.find_by_id(params[:country_id]) unless params[:country_id].nil?
    return if @selected_country.nil?
    market_ids = @selected_country.markets.collect {|market| market.id}
    
    @list_of_markets = []
    @list_of_market_datacenter_owners = Array.new
        
    @market_numbers = Hash.new
    DatacenterPoi.find(:all,:conditions => ["market_id in (:markets) #{poi_hosting_where_clause}", {:markets => market_ids}]).each do |dc_poi|
      @market_numbers[dc_poi.networkterminationpoint.owner] = Hash.new if @market_numbers[dc_poi.networkterminationpoint.owner].nil?
      @list_of_market_datacenter_owners << dc_poi.networkterminationpoint.owner unless @list_of_market_datacenter_owners.include?(dc_poi.networkterminationpoint.owner)
      @list_of_markets << dc_poi.market unless @list_of_markets.include?(dc_poi.market)
      @market_numbers[dc_poi.networkterminationpoint.owner][dc_poi.market] = Array.new if @market_numbers[dc_poi.networkterminationpoint.owner][dc_poi.market].nil?
      @market_numbers[dc_poi.networkterminationpoint.owner][dc_poi.market] << dc_poi.poi2ntp
    end
    @list_of_market_datacenter_owners.sort! {|x,y| ((x.name.downcase=="equinix")?('   Equinix'):(x.name.downcase)) <=> ((y.name.downcase=="equinix")?('   Equinix'):(y.name.downcase))}
    @list_of_markets.sort! {|x,y| x.market_name.downcase <=> y.market_name.downcase}
    
    render :partial => 'poi_hosting_market' and return unless update_only
  end
  
  def poi_hosting_where_clause
    class_where_clause_items = []
    unless @all_classes
      class_where_clause_items << 'equities_class = 1' if @equities_class
      class_where_clause_items << 'fixed_income_class = 1' if @fixed_income_class
      class_where_clause_items << 'foreign_exchange_class = 1' if @foreign_exchange_class
      class_where_clause_items << 'futures_class = 1' if @futures_class
    else
      class_where_clause_items << '1=1'
    end
    
    connection_where_clause_items = []
    connection_where_clause_items << 'poiconnectiontype_id = 1' if @type_1
    connection_where_clause_items << 'poiconnectiontype_id = 2' if @type_2
    
    return "and 1=2" if class_where_clause_items.size == 0 or connection_where_clause_items.size == 0
    return "and (#{class_where_clause_items.join(' or ')}) and (#{connection_where_clause_items.join(' or ')})"
  end
  
  def update_poi_hosting
    @fixed_income_class = (params[:fixed_income]?true:false)
    @foreign_exchange_class = (params[:foreign_exchange]?true:false)
    @futures_class = (params[:futures]?true:false)
    @equities_class = (params[:equities]?true:false)
    @all_classes = (params[:all_classes]?true:false)
    @type_1 = (params[:type_1]?true:false)
    @type_2 = (params[:type_2]?true:false)
    @selected_region = Equinixregion.find_by_id(params[:region_id]) unless params[:region_id].nil?
    @selected_country = Country.find_by_id(params[:country_id]) unless params[:country_id].nil?
       
    poi_hosting_region
    poi_hosting_country(true)
    poi_hosting_market(true)
    render :partial => 'poi_hosting_all_views', :locals => {:current_view => params[:current_view]}
  end
  
  def poi_hosting_scorecard
    redirect_to :action => 'index' if @current_user.networktermptowners.empty? or @current_user.networktermptowners.find_by_name('Equinix').nil?
    class_where_clause_items = []
    unless @all_classes
      where_clause_items << 'equities_class = 1' if @equities_class
      where_clause_items << 'fixed_income_class = 1' if @fixed_income_class
      where_clause_items << 'foreign_exchange_class = 1' if @foreign_exchange_class
      where_clause_items << 'futures_class = 1' if @futures_class
    end
    
    connection_where_clause_items = []
    connection_where_clause_items << 'poiconnectiontype_id = 1' if @type_1
    connection_where_clause_items << 'poiconnectiontype_id = 2' if @type_2
    
    poi_hosting_region
  end
  
  def poi_hosting_region
    @subnav = "scorecard"
    session[:original_uri] = request.request_uri
    session[:page] = 'poi_hosting_scoreboard'
    
    @fixed_income_class = true if @fixed_income_class.nil?
    @foreign_exchange_class = true if @foreign_exchange_class.nil?
    @futures_class = true if @futures_class.nil?
    @equities_class = true if @equities_class.nil?
    @all_classes = true if @all_classes.nil?
    @type_1 = true if @type_1.nil?
    @type_2 = true if @type_2.nil?
    
    @list_of_regions = []
    @list_of_region_datacenter_owners = Array.new
    
    @region_numbers = Hash.new
    DatacenterPoi.find(:all,:conditions => ["1=1 #{poi_hosting_where_clause}"]).each do |dc_poi|
      owner = dc_poi.networkterminationpoint.owner
      unless owner.nil?
        region = dc_poi.country.subregion.equinixregion
        @region_numbers[owner] = Hash.new if @region_numbers[owner].nil?
        @list_of_region_datacenter_owners << owner unless @list_of_region_datacenter_owners.include?(owner)
        @list_of_regions << region unless @list_of_regions.include?(region)
        @region_numbers[owner][region] = Array.new if @region_numbers[owner][region].nil?
        @region_numbers[owner][region] << dc_poi.poi2ntp
      end
    end
    @list_of_region_datacenter_owners.sort! {|x,y| ((x.name.downcase=="equinix")?('   Equinix'):(x.name.downcase)) <=> ((y.name.downcase=="equinix")?('   Equinix'):(y.name.downcase))}
    @list_of_regions.sort! {|x,y| x.region_name.downcase <=> y.region_name.downcase}
  end
  
  
  def view_network_services
    @subnav = "view_network_services"
    session[:original_uri] = request.request_uri
    session[:page] = 'view_network_services'
    @page = session[:page]
    
    (@list_of_regions = Equinixregion.find(:all).collect { |region| [region.region_name, "#{region.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase }
    @list_of_countries = get_list_of_countries
    @list_of_ntps = get_list_of_ntp_options.insert(0,['All','-1'])
    
    session[:selected_countries] = session[:selected_countries].delete_if {|x| !opt_list_contains_id(@list_of_countries,x)} if session[:selected_countries] != nil
    session[:selected_ntps] = session[:selected_ntps].delete_if {|x| !opt_list_contains_id(@list_of_ntps,x)} if session[:selected_ntps] != nil
    session[:selected_regions] = ['-1'] if session[:selected_regions] == nil
    session[:selected_countries] = ['-1'] if session[:selected_countries] == nil
    session[:selected_ntps] = ['-1'] if session[:selected_ntps] == nil
    @selected_regions = session[:selected_regions]
    @selected_countries = session[:selected_countries]
    @selected_ntps = session[:selected_ntps]
    
    if session[:selected_ntps] != nil then
      if session[:selected_ntps].include?('-1') then
        @list_of_display_ntps = get_list_of_ntps
      else
        @list_of_display_ntps = Networkterminationpoint.find(:all,:conditions => ["id in (:ntps)", {:ntps => session[:selected_ntps]}]).sort {|x,y| x.name.downcase <=> y.name.downcase }
      end
      @network_services = get_network_services
    end 
  end
  
  
  def competitive_market_report_options
    @subnav = "market_report"
    session[:original_uri] = request.request_uri
    session[:page] = 'competitive_market_report_options'
    @selected_market = params[:selected_market]
    @markets = Market.find(:all)
  end
  
  
  def view_competitive_market_report
    session[:original_uri] = request.request_uri
    session[:page] = 'view_competitive_market_report'
    @market = Market.find_by_id(params[:id])
    @unit = "_metric" if params[:unit] == "M"
    @unit = "_british" if params[:unit] == "B"
    @center = get_center_of_market_map(@market)
  end
  
  def prospects_report_report_options
    @subnav = "prospects_report"
    if request.post? then
      session[:prospect_status_types] = params[:options][:types]
      session[:public_report] = params[:options][:public]
      session[:selected_regions] = params[:selected_regions]
      redirect_to :action => :view_prospects_report
    end
  end
  
  def view_prospects_report
    session[:original_uri] = request.request_uri
    session[:page] = 'view_prospects_report'
    session[:selected_regions] = "1,2,3,4".split(',') if !session[:selected_regions]
    @owner = params[:owner]
    @filename = params[:filename]
    @selected_regions = session[:selected_regions].collect {|region_id| region_id.to_i }
    @selected_regions.delete_if {|x| x < 1 or x > 4}
    @prospect_status_types = session[:prospect_status_types]
    @regions_markets_array = Array.new
    Market.find(:all).each do |market|
      if @selected_regions.include?(market.country.subregion.equinixregion.id) then
        @regions_markets_array << {:region => market.country.subregion.equinixregion, :market => market, :to_str => "#{market.country.subregion.equinixregion.region_name} #{market.market_name}"}
      end
    end
    @poi_prospects_list = Array.new
    Pointsofinterest.find(:all).each do |poi|
      prospects = Array.new
      poi.all_ntp_connections.each do |prospect|
        if prospect.networkterminationpoint.owner.name == 'Equinix' and \
            ((session[:public_report] == "Yes" and prospect.public) or session[:public_report] == "No") and \
            @selected_regions.include?(prospect.networkterminationpoint.parentcountry.subregion.equinixregion.id) and \
            (session[:prospect_status_types] == 'All' or (session[:prospect_status_types] == 'All_Non_Live' and prospect.prospectstatustype_id != 1) or (session[:prospect_status_types] == 'Targeted' and prospect.prospectstatustype_id == 4)) then 
          if prospect.networkterminationpoint.datacenterdetail == nil or prospect.networkterminationpoint.datacenterdetail.market.nil? then
            prospect_region_market = "#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name} #{prospect.networkterminationpoint.parentcountry.name}"
          else
            prospect_region_market = "#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name} #{prospect.networkterminationpoint.datacenterdetail.market_name}"
          end
          if !(@regions_markets_array.collect {|x| x[:to_str]}).include?(prospect_region_market) then
            if prospect.networkterminationpoint.datacenterdetail == nil or prospect.networkterminationpoint.datacenterdetail.market == nil then
              @regions_markets_array << {:region => prospect.networkterminationpoint.parentcountry.subregion.equinixregion, :country => prospect.networkterminationpoint.parentcountry, :to_str => prospect_region_market}
            else
              @regions_markets_array << {:region => prospect.networkterminationpoint.parentcountry.subregion.equinixregion, :market => prospect.networkterminationpoint.datacenterdetail.market, :to_str => prospect_region_market}
            end
          end
          prospects << prospect
        end
      end
      @poi_prospects_list << {:poi => poi, :prospects => prospects} if prospects.size > 0
    end
    @poi_prospects_list.sort! {|x,y| x[:poi].name.downcase <=> y[:poi].name.downcase}
    @region_child_count = [0,0,0,0,0]
    @regions_markets_array.each do |region_market|
      @region_child_count[region_market[:region].id] += 1
    end
    @region_count = 0
    @region_child_count.each { |x| @region_count += 1 if x > 0 }
    @regions_markets_array.sort! {|x,y| x[:to_str].downcase <=> y[:to_str].downcase}
    @regions_markets_total_array = Array.new
    @regions_markets_array.each { |x| @regions_markets_total_array << {'1' => 0, '2' => 0, '3' => 0, '4' => 0} }
    @a_connection_explanation = Poiconnectiontype.find(:first,:conditions => ["name = 'A'"]).description
    @b_connection_explanation = Poiconnectiontype.find(:first,:conditions => ["name = 'B'"]).description
  end
  
  def view_equinix_metro_reports
    @subnav = "equinix_metro_report"
    @markets = Market.find(:all,:order => 'market_name')
  end
  
  def pdf_prospects_report
    
    view_prospects_report
        
    prospect_pdf = PDF::Writer.new(:paper => [27.94,35.56])
    old_left_margin = prospect_pdf.left_margin
    old_top_margin = prospect_pdf.top_margin
    prospect_pdf.left_margin = 0
    prospect_pdf.top_margin = 0
    prospect_pdf.select_font "Times-Roman"
    prospect_pdf.stroke_color Color::RGB::Black
    prospect_pdf.rectangle(0,prospect_pdf.page_height-45,prospect_pdf.page_width,45).fill
    prospect_pdf.fill_color Color::RGB::Red
    prospect_pdf.rectangle(0,prospect_pdf.page_height-46,prospect_pdf.page_width,1).fill
    y_position = prospect_pdf.y + 0
    prospect_pdf.add_image_from_file("http://www.circuitclout.com/images/Equinix_GUIDE.png",10,y_position,84,30)
    prospect_pdf.add_image_from_file("http://www.circuitclout.com/images/equinix_logo.png",prospect_pdf.page_width-70,y_position+2,55,28)
    
    prospect_pdf.left_margin = old_left_margin
    prospect_pdf.top_margin = old_top_margin
    prospect_pdf.fill_color Color::RGB::Black
    prospect_pdf.text ' ', :font_size => 10, :justification => :center
    
    all_table = PDF::SimpleTable.new
    all_table.font_size = 7
    all_table.maximum_width = prospect_pdf.page_width + 20
    all_table.position = :center
    all_table.orientation = :center
    all_table.shade_heading_color = Color::RGB::Black
    all_table.shade_headings = true
    all_table.heading_color = Color::RGB::White
    all_table.heading_font_size = 9
    all_table.data = []
    all_markets = []
    
    region_tables = Hash.new
    region_markets = Hash.new
    @selected_regions.each do |region_id|
      region_tables[region_id] = PDF::SimpleTable.new
      region_tables[region_id].font_size = 7
      region_tables[region_id].maximum_width = 540
      region_tables[region_id].position = :center
      region_tables[region_id].orientation = :center
      region_tables[region_id].shade_heading_color = Color::RGB::Black
      region_tables[region_id].shade_headings = true
      region_tables[region_id].heading_color = Color::RGB::White
      region_tables[region_id].heading_font_size = 9
      region_tables[region_id].data = []
      region_markets[region_id] = []
    end
    
    @poi_prospects_list.each do |poi_prospects|
      all_data_row = {'poi' => poi_prospects[:poi].name}
      region_data_row = Hash.new
      @selected_regions.each {|region_id| region_data_row[region_id] = {'poi' => poi_prospects[:poi].name} }
      poi_prospects[:prospects].each do |prospect|
        unless prospect.networkterminationpoint.datacenterdetail.nil? or prospect.networkterminationpoint.datacenterdetail.market.nil?
          market_name = prospect.networkterminationpoint.datacenterdetail.market.market_name 
        else
          market_name = prospect.networkterminationpoint.parentcountry.name
        end
        region_id = prospect.networkterminationpoint.parentcountry.subregion.equinixregion.id
        region_markets[region_id] << market_name unless region_markets[region_id].include?(market_name)
        all_markets << "#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name}\n#{market_name}" unless all_markets.include?("#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name}\n#{market_name}")
        color = ((prospect.status.id == 1)?('60,185,60'):((prospect.status.id == 2)?('185,185,60'):((prospect.status.id == 3)?('185,140,30'):('205,60,60'))))
        unless all_data_row["#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name} #{prospect.networkterminationpoint.datacenterdetail.market_name}"].nil?
          all_data_row["#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name}\n#{market_name}"] += "\ncolor::#{color}:: #{prospect.connectiontype.name} - #{prospect.networkterminationpoint.name}"
          region_data_row[region_id][market_name] += "\ncolor::#{color}:: #{prospect.connectiontype.name} - #{prospect.networkterminationpoint.name}"
        else
          all_data_row["#{prospect.networkterminationpoint.parentcountry.subregion.equinixregion.region_name}\n#{market_name}"] = "color::#{color}:: #{prospect.connectiontype.name} - #{prospect.networkterminationpoint.name}"
          region_data_row[region_id][market_name] = "color::#{color}:: #{prospect.connectiontype.name} - #{prospect.networkterminationpoint.name}"
        end
      end
      all_table.data << all_data_row
      region_data_row.each_pair do |region_id, data_row|
        if data_row.length > 1 then
          region_tables[region_id].data << data_row
        end
      end
    end
    
    all_table.columns['poi'] = PDF::SimpleTable::Column.new('poi') {|col| col.heading = "Point of Interest" }
    all_table.column_order = ['poi']
    (all_markets.sort {|x,y| x.downcase <=> y.downcase}).each do |market| 
      all_table.columns[market] = PDF::SimpleTable::Column.new(market) {|col| col.heading = market.upcase; col.heading.justification = :center; }
      all_table.column_order << market
    end
    prospect_pdf.text "Prospects Report", :font_size => 20, :justification => :center unless all_table.data.size == 0
    prospect_pdf.text ' ', :font_size => 10, :justification => :center unless all_table.data.size == 0
    all_table.render_on(prospect_pdf) unless all_table.data.size == 0
    prospect_pdf.text ' ', :font_size => 20, :justification => :center unless all_table.data.size == 0
=begin
    region_markets.each_pair do |region_id,markets| 
      region_tables[region_id].columns['poi'] = PDF::SimpleTable::Column.new('poi') {|col| col.heading = "Point of Interest".upcase }
      region_tables[region_id].column_order = ['poi']
      (markets.sort {|x,y| x.downcase <=> y.downcase}).each do |market| 
        region_tables[region_id].columns[market] = PDF::SimpleTable::Column.new(market) {|col| col.heading = market.upcase }
        region_tables[region_id].column_order << market
      end
      prospect_pdf.text ' ', :font_size => 20, :justification => :center unless region_tables[region_id].data.size == 0
      prospect_pdf.text "<b>#{Equinixregion.find_by_id(region_id).region_name.upcase}</b>", :font_size => 20, :justification => :center unless region_tables[region_id].data.size == 0
      prospect_pdf.text ' ', :font_size => 10, :justification => :center unless region_tables[region_id].data.size == 0
      region_tables[region_id].render_on(prospect_pdf) unless region_tables[region_id].data.size == 0
    end
=end
    prospect_pdf.text " ",:font_size => 11
    prospect_pdf.text "<b>Legend</b>",:font_size => 11
    prospect_pdf.left_margin += 10
    prospect_pdf.text "A - #{@a_connection_explanation }", :font_size => 9
    prospect_pdf.text "B - #{@b_connection_explanation }", :font_size => 9
    #prospect_pdf.stroke_style(PDF::Writer::StrokeStyle.new(1))
    #prospect_pdf.stroke_color(Color::RGB::Black)
    #prospect_pdf.text_render_style(2)
    prospect_pdf.fill_color(Color::RGB.new(60,185,60))
    prospect_pdf.text "<b>Green - Live Connection</b>", :font_size => 9
    prospect_pdf.fill_color(Color::RGB.new(185,185,60))
    prospect_pdf.text "<b>Yellow - Signed but not yet live</b>", :font_size => 9
    prospect_pdf.fill_color(Color::RGB.new(185,140,30))
    prospect_pdf.text "<b>Orange - Pipeline</b>", :font_size => 9
    prospect_pdf.fill_color(Color::RGB.new(205,60,60))
    prospect_pdf.text "<b>Red - Targeted</b>", :font_size => 9
    
    send_data prospect_pdf.render, :filename => "Prospects-Report.pdf",
              :type => "application/pdf"
  end
  
  def test_john_king
    @market = Market.find_by_id(params[:id])
    @center = get_center_of_market_map(@market)
  end
  
  def get_kml_overlay_for_competitive_markets
    headers['Content-Type'] = "application/kml"
    headers['Cache-Control'] = ''
    @market = Market.find_by_id(params[:id])
    @id = params[:id]
    @center = get_center_of_market_map(@market) 
    render :layout => false
  end
  
  def market_latencytime_grid
    
  end

  # *****************PRIVATE METHODS***********************
  private
  
  def build_market_kml_file(market)
    session[:selected_ntps] = market.datacenters.collect {|datacenter| datacenter.networkterminationpoint.id }
    kml_file_text = make_kml_document('Market Datacenters',get_kml_styles("\t"), ntps_to_placemarks("\t",session[:selected_ntps]))
    if File.exist?("#{RAILS_ROOT}/public/market_#{market.id}.kml") then
      kml_file = File.open("#{RAILS_ROOT}/public/market_#{market.id}.kml",File::TRUNC|File::WRONLY)
    else
      kml_file = File.open("#{RAILS_ROOT}/public/market_#{market.id}.kml",File::CREAT|File::WRONLY)
    end
    kml_file.print kml_file_text
    kml_file.close
  end
  
  def make_kml_document(name, styles, placemarks)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://earth.google.com/kml/2.2\">\n<Document>\n\t<name>#{name}</name>#{styles}#{placemarks}\n</Document>\n</kml>\n"
  end
  
  def get_ntp_style_type(ntp)
    return 'builder' if ntp.is_future_build == true
    if ntp.owner.name == 'Equinix' then
      #if ntp.coordinates_exact == true then
      #  return 'green-with-dot'
      #else
      #  return 'green-no-dot'
      #end
      return 'equinix'
    else
      if ntp.type.name == 'Datacenter' then
        if ntp.coordinates_exact == true then
          return 'red-with-dot'
        else
          return 'red-no-dot'
        end
      else
        if ntp.coordinates_exact == true then
          return 'blue-with-dot'
        else
          return 'blue-no-dot'
        end
      end
    end
  end
  
  def get_poi_style_type(ntp)
    if ntp.coordinates_exact == true then
      return 'white-with-dot'
    else
      return 'white-no-dot'
    end
  end
  
  def pois_to_placemarks(indent, pois)
    placemarks = ''
    pois.each do |pointsofinterest_id|
      poi = Pointsofinterest.find_by_id(pointsofinterest_id)
      poi.ntp_connections.each do |ntp_connection|
        ntp = ntp_connection.networkterminationpoint
        placemarks += make_kml_placemark_from_poi(indent,poi,ntp) if ntp.lon != nil and ntp.lat != nil and !ntp.lon.blank? and !ntp.lat.blank?
      end if poi != nil
    end
    placemarks
  end
  
  def ntps_to_placemarks(indent, ntps)
    placemarks = ''
    ntps.each do |networkterminationpoint_id|
      ntp = Networkterminationpoint.find_by_id(networkterminationpoint_id)
      placemarks += make_kml_placemark_from_ntp(indent,ntp) if ntp != nil and ntp.lon != nil and ntp.lat != nil and !ntp.lon.blank? and !ntp.lat.blank?
    end
    placemarks
  end
  
  def poi2ntps_to_placemarks(indent, poi2ntps)
    placemarks = ''
    poi2ntps.each do |poi2networkterminationpoint_id|
      poi2ntp = Poi2ntp.find_by_id(poi2networkterminationpoint_id)
      ntp = poi2ntp.networkterminationpoint
      placemarks += make_kml_placemark_from_poi(indent,poi2ntp.poi,ntp) if ntp.lon != nil and ntp.lat != nil and !ntp.lon.blank? and !ntp.lat.blank?
    end
    placemarks
  end
  
  def make_kml_placemark_from_poi(indent,poi,ntp)
    description = "#{indent}<![CDATA[\n#{indent}\t"
    description += "<b>Point of Interest Name:</b><br/>#{escapeKML(poi.name)}<br/>"
    description += "<i>#{escapeKML(poi.notes)}</i><br/>" if poi.notes != nil and !poi.notes.blank?
    if poi.parent_poi != nil then
      description += "<b>Parent Point of Interest:</b><br/>#{escapeKML(poi.parent_poi.name)}<br/>"
      description += "<i>#{escapeKML(poi.parent_poi.notes)}</i><br/>" if poi.parent_poi.notes != nil and !poi.parent_poi.notes.blank? and poi.parent_poi.notes != poi.notes
    end
    description += "<b>Location Name:</b><br/>#{escapeKML(ntp.name)}<br/>"
    description += "<b>Address:</b><br/>#{escapeKML(print_full_addr(ntp))}<br/>"
    description += "\n#{indent}]]>#{indent}"
    return_str = "\n#{indent}<Placemark>\n#{indent}\t<name>#{escapeKML(poi.name)}</name>\n#{indent}\t<description>#{escapeKML(description)}</description>"
    return_str += "\n#{indent}\t<styleUrl>##{get_poi_style_type(ntp)}</styleUrl>\n#{indent}\t<Point>\n#{indent}\t\t<coordinates>#{ntp.lon},#{ntp.lat},0</coordinates>\n#{indent}\t</Point>\n#{indent}</Placemark>"
    return_str
  end
  
  def make_kml_placemark_from_ntp(indent,ntp)
    description = "#{indent}<![CDATA[\n#{indent}\t"
    description += "<b>Address:</b><br/>#{escapeKML(print_full_addr(ntp))}<br/>"
    if ntp.datacenterdetail != nil then
      description += "<br/><b>Quality Type: </b>#{ntp.datacenterdetail.quality_type.quality_type if ntp.datacenterdetail.quality_type != nil}"
      description += "<br/><b>Floor Size: </b>#{get_field_match_units(ntp.datacenterdetail,'floor_capacity')} #{ get_long_unit_name('area') }"
      description += "<br/><b>Available Space: </b>#{(get_field_match_units(ntp.datacenterdetail,'floor_capacity')*(1 - (ntp.datacenterdetail.occupancy_rate/100.0))).round if ntp.datacenterdetail.occupancy_rate != nil and get_field_match_units(ntp.datacenterdetail,'floor_capacity') != nil} #{ get_long_unit_name('area') }<br/>"
    end
    description += "<br/><b>Financial Exchanges:</b><ul>" + (ntp.poi_connections.collect {|poi_connection| "<li>#{escapeKML(poi_connection.poi.name)}</li>"}).join + '</ul>'
    description += "<br/><b>Network Providers:</b>#{escapeKML(get_grouped_list_of_np2ntps(ntp))}"
    description += "\n#{indent}]]>#{indent}"
    return_str = "\n#{indent}<Placemark>\n#{indent}\t<name>#{escapeKML(ntp.name)}</name>\n#{indent}\t<description>#{escapeKML(description)}</description>"
    return_str += "\n#{indent}\t<styleUrl>##{get_ntp_style_type(ntp)}</styleUrl>\n#{indent}\t<Point>\n#{indent}\t\t<coordinates>#{ntp.lon},#{ntp.lat},0</coordinates>\n#{indent}\t</Point>\n#{indent}</Placemark>"
    return_str
  end
  
  def get_grouped_list_of_np2ntps(ntp)
    typeHash = Hash.new
    ntp.np_connections.collect do |np_connection| 
      typeHash[np_connection.details] = Array.new if typeHash[np_connection.details] == nil 
      typeHash[np_connection.details] << np_connection.networkprovider.name
    end
    if typeHash.size == 0 then
      return '<br/>'
    else
      listString = ''
    end
    typeHash.each_pair do |key, value|
      listString += "<br/>#{key}<ul>"
      listString += (value.collect {|np| "<li>#{np}</li>"}).join
      listString += '</ul>'
    end
    listString
  end
  
  def make_kml_folder(indent, name, open, content)
    "\n#{indent}<Folder>\n#{indent}\t<name>#{name}</name>\n#{indent}\t<open>#{open}</open>#{content}\n#{indent}</Folder>"
  end
    
  def get_kml_styles(indent)
    styles = "\n#{indent}<Style id=\"default\">\n#{indent}\t<IconStyle>\n#{indent}\t\t<Icon>\n#{indent}\t\t</Icon>\n#{indent}\t</IconStyle>\n#{indent}</Style>"
    styles += make_google_highlight_pair_style_map(indent,'blue-with-dot','1.1','1.3','blu-circle','ffffaa55','blu-circle-lv')
    styles += make_google_highlight_pair_style_map(indent,'green-with-dot','1.1','1.3','grn-circle','ff7fff55','grn-circle-lv')
    styles += make_google_highlight_pair_style_map(indent,'red-with-dot','1.1','1.3','red-circle','ff7f55ff','red-circle-lv')
    styles += make_google_highlight_pair_style_map(indent,'white-with-dot','1.1','1.3','wht-circle','ffffffff','wht-circle-lv')
    styles += make_google_highlight_pair_style_map(indent,'blue-no-dot','1.1','1.3','blu-blank','ffffaa55','blu-blank-lv')
    styles += make_google_highlight_pair_style_map(indent,'green-no-dot','1.1','1.3','grn-blank','ff7fff55','grn-blank-lv')
    styles += make_google_highlight_pair_style_map(indent,'red-no-dot','1.1','1.3','red-blank','ff7f55ff','red-blank-lv')
    styles += make_google_highlight_pair_style_map(indent,'white-no-dot','1.1','1.3','wht-blank','ffffffff','wht-blank-lv')
    styles += make_highlight_pair_style_map(indent, 'equinix', '1.3', '1.5', 'http://circuitclout.com/images/markers/equinix.png', 'ff0101ff', 'http://circuitclout.com/images/markers/equinix-lv.png')
    styles += make_highlight_pair_style_map(indent,'builder','1.1','1.3','http://maps.google.com/mapfiles/kml/shapes/mechanic.png','ff33ffff','http://maps.google.com/mapfiles/kml/shapes/mechanic.png')
    styles += make_legend_screen_overlay(indent,"http://www.circuitclout.com/images/google_earth_legend.jpg")
    styles
  end
  
  def make_legend_screen_overlay(indent,url)
    overlay = "\n#{indent}<ScreenOverlay>"
    overlay += "\n#{indent}\t<name>Legend</name>"
    overlay += "\n#{indent}\t<visibility>1</visibility>"
    overlay += "\n#{indent}\t<Icon><href>#{url}</href></Icon>"
    overlay += "\n#{indent}\t<overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>"
    overlay += "\n#{indent}\t<screenXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>"
    overlay += "\n#{indent}\t<rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>"
    overlay += "\n#{indent}\t<size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>"
    overlay += "\n#{indent}</ScreenOverlay>"
    overlay
  end
  
  def make_google_highlight_pair_style_map(indent, id, scale1, scale2, icon_name, label_color, icon_item_name)
    return_str = make_google_kml_style(indent, "#{id}-#{scale1}", scale1, icon_name, label_color, icon_item_name)
    return_str += make_google_kml_style(indent, "#{id}-#{scale2}", scale2, icon_name, label_color, icon_item_name)
    return_str += "\n#{indent}<StyleMap id=\"#{id}\">\n#{indent}\t<Pair>\n#{indent}\t\t<key>normal</key>\n#{indent}\t\t<styleUrl>##{id}-#{scale1}</styleUrl>\n#{indent}\t</Pair>"
    return_str += "\n#{indent}\t<Pair>\n#{indent}\t\t<key>highlight</key>\n#{indent}\t\t<styleUrl>##{id}-#{scale2}</styleUrl>\n#{indent}\t</Pair>\n#{indent}</StyleMap>"
    return_str
  end
  
  def make_highlight_pair_style_map(indent, id, scale1, scale2, icon_name, label_color, icon_item_name)
    return_str = make_kml_style(indent, "#{id}_#{scale1}", scale1, icon_name, label_color, icon_item_name)
    return_str += make_kml_style(indent, "#{id}_#{scale2}", scale2, icon_name, label_color, icon_item_name)
    return_str += "\n#{indent}<StyleMap id=\"#{id}\">\n#{indent}\t<Pair>\n#{indent}\t\t<key>normal</key>\n#{indent}\t\t<styleUrl>#{id}_#{scale1}</styleUrl>\n#{indent}\t</Pair>"
    return_str += "\n#{indent}\t<Pair>\n#{indent}\t\t<key>highlight</key>\n#{indent}\t\t<styleUrl>#{id}_#{scale2}</styleUrl>\n#{indent}\t</Pair>\n#{indent}</StyleMap>"
    return_str
  end
  
  def make_google_kml_style(indent, id, scale, icon_name, label_color, icon_item_name)
    if icon_item_name == 'red-blank-lv' then
      make_kml_style(indent, id, scale, "http://maps.google.com/mapfiles/kml/paddle/#{icon_name}.png", label_color, 'http://kelvcutler.googlepages.com/red-blank-lv.png')
    else
      make_kml_style(indent, id, scale, "http://maps.google.com/mapfiles/kml/paddle/#{icon_name}.png", label_color, "http://maps.google.com/mapfiles/kml/paddle/#{icon_item_name}.png")
    end
  end
  
  def make_kml_style(indent, id, scale, icon, label_color, icon_item)
    new_line = "\n#{indent}"
    return_str = "#{new_line}<Style id=\"#{id}\">#{new_line}\t<IconStyle>#{new_line}\t\t<scale>#{scale}</scale>#{new_line}\t\t<Icon>#{new_line}\t\t\t<href>#{icon}</href>"
    return_str += "#{new_line}\t\t</Icon>#{new_line}\t\t<hotSpot x=\"32\" y=\"1\" xunits=\"pixels\" yunits=\"pixels\"/>#{new_line}\t</IconStyle>"
    return_str += "#{new_line}\t<LabelStyle>#{new_line}\t\t<color>#{label_color}</color>#{new_line}\t</LabelStyle>"
    return_str += "#{new_line}\t<ListStyle>#{new_line}\t\t<ItemIcon>#{new_line}\t\t\t<href>#{icon_item}</href>#{new_line}\t\t</ItemIcon>#{new_line}\t</ListStyle>#{new_line}</Style>"
    return_str
  end
  
  def np_connects_to_poi_in_list(campus,np,poi_obj_list)
    poi_obj_list.each do |poi_obj|
      poi_obj[2].each do |ntp_obj|
        ntp_obj[1].np_connections.each do |np_connection|
          return true if np_connection.networkprovider == np
        end if ntp_obj[1].np_connections != nil and (campus.nil? or !campus.contains_ntp(ntp_obj[1]))
      end if poi_obj[2] != nil
    end
    return false
  end
  
  
  def print_addr_summary(ntp)
    returnString = ''
    returnString += ntp.city + ', ' unless ntp.city.blank?
    returnString += ntp.state_or_province + ', ' unless ntp.state_or_province.blank?
    returnString += "<br/>#{ntp.country.name}" if ntp.country
  end
  
  
  def print_full_addr(ntp)
    returnString = ''
    returnString += ntp.street_address
    returnString += "<br/>Floor: #{ntp.floor}" unless ntp.floor.blank?
    returnString += "<br/>Suite: #{ntp.suite}" unless ntp.suite.blank?
    returnString += "<br/>#{ntp.city}" unless ntp.city.blank?
    returnString += ", #{ntp.state_or_province}" unless ntp.state_or_province.blank?
    returnString += " #{ntp.zip_code}" unless ntp.zip_code.blank?
    returnString += "<br/>#{ntp.country.name}" if ntp.country
    returnString
  end
  
  
  def get_list_of_countries
    if session[:selected_regions] == nil or session[:selected_regions].include?('-1')
      list_of_countries = Country.find(:all).collect { |country| [country.name, "#{country.id}"] if country.networkterminationpoints }
    else
      list_of_countries = Array.new
      regions = Equinixregion.find(:all,:conditions => ["id in (:regions)", {:regions => session[:selected_regions]}])
      regions.each do |region|
        region.subregions.each do |subregion|
          subregion.countries.each { |country| list_of_countries <<  [country.name, "#{country.id}"] if country.networkterminationpoints }
        end
      end
    end
    return list_of_countries.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_ntp_options
    return (get_list_of_ntps.collect {|ntp| [ntp.name,ntp.id]}).sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_ntps
    list_of_ntps = Array.new
    if session[:selected_countries] == nil or session[:selected_countries].include?('-1') then
      if session[:selected_regions] == nil or session[:selected_regions].include?('-1') then
        list_of_ntps = Networkterminationpoint.find(:all).sort {|x,y| x.name.downcase <=> y.name.downcase }
      else
        session[:selected_regions].each do |region_id|
          region = Equinixregion.find_by_id(region_id)
          if region then
            list_of_ntps += region.networkterminationpoints
          end
        end
      end
    else
      session[:selected_countries].each do |country_id|
        country = Country.find_by_id(country_id)
        if country then
          list_of_ntps += country.networkterminationpoints
        end
      end
    end
    list_of_ntps
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
  
  
  def get_km_distance(ntpSelf, ntpOther)
    if ntpOther.lat == nil or ntpOther.lon == nil or ntpSelf.lat == nil or ntpSelf.lon == nil then
      return 999999
    end
    other_lat = ntpOther.lat.to_f
    other_lon = ntpOther.lon.to_f
    self_lat = ntpSelf.lat.to_f
    self_lon = ntpSelf.lon.to_f
    to_rads = Math::PI / 180.0
    d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    d
  end
  
  def prospect_list_include?(prospects,prospect_or_ntp_connection)
    prospects.each do |prospect|
      return true if prospect.pointsofinterest_id == prospect_or_ntp_connection.pointsofinterest_id and prospect.networkterminationpoint_id == prospect_or_ntp_connection.networkterminationpoint_id and prospect.connectiontype_id == prospect_or_ntp_connection.connectiontype_id
    end
    return false
  end
end
