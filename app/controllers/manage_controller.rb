class ManageController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  layout 'application', :except => [:select_region, :show_poi]
  
  def index
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_region'
    session[:selected_region] = '-1'
    session[:selected_country] = '-1'
    session[:selected_poi] = '-1'
    session[:selected_service] = '-1'
    session[:selected_networktermptowner_id] = '-1'
    session[:selected_networktermpttype_id] = '-1'
    session[:selected_subregion] = '-1'
    if @current_user.is_equinix? then
      redirect_to :controller => 'salesinfo', :action => 'poi_hosting_scorecard'
    else
      redirect_to :controller => 'salesinfo', :action => 'home'
    end
  end 
  
  def select_region
    if params[:page]
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_region] = params[:id]
    @selected_region = session[:selected_region]
    @selector_size = 5
    session[:selected_country] = '-1'
    session[:selected_poi] = '-1'
    session[:selected_service] = '-1'
    session[:selected_subregion] = '-1'
    if session[:page] == 'edit_market' then
      @list_of_countries = get_list_of_countries
      @selected_market = '-1'
      @partial_type = 'selector'
      render(:partial => 'country_selector', :layout => false)   
    else
      @list_of_countries = get_list_of_countries
      @partial_type = 'selector'
      render(:partial => 'country_selector', :layout => false)   
    end
  end
  
  def select_subregion
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_subregion] = params[:id]
    session[:selected_country] = '-1'
    session[:selected_poi] = '-1'
    session[:selected_service] = '-1'
    redirect_to :action => session[:page]
  end
  
  def select_market
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_market] = params[:id]
  end
  
  def select_country
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_country] = params[:id]
    @selected_country = session[:selected_country]
    @selector_size = 5
    session[:selected_poi] = '-1'
    session[:selected_service] = '-1'
    session[:selected_market] = '-1'
    if session[:page] == 'edit_market'
      @list_of_markets = get_list_of_markets
      @selected_market = '-1'
      render(:partial => 'market_selector', :layout => false)
    else
      redirect_to :action => session[:page]
    end
  end
  
  def select_poi
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_poi] = params[:id]
    @selected_poi = params[:id]
    session[:selected_service] = '-1'
    if session[:page] == 'edit_service' then
      @list_of_services = get_list_of_services_dependent
      render(:partial => 'service_selector', :layout => false) 
    else
      redirect_to :action => session[:page]
    end
  end
  
  def select_ntp_owner
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_networktermptowner_id] = params[:id]
    session[:selected_ntp] = '-1'
    session[:selected_campus] = '-1'
    @list_of_campuses = get_list_of_campuses
    @selected_campus = '-1'
    @partial_type = 'editor'
    render(:partial => 'campus_selector', :layout => false)
  end  
  
  def select_networktermpttype_id
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    session[:selected_networktermpttype_id] = params[:id]
    session[:selected_ntp] = '-1'
    redirect_to :action => session[:page]
  end
  
  def select_ntp
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    @previous_selection = session[:selected_ntp]
    session[:selected_ntp] = params[:id]
    if session[:page] == 'edit_ntp' then
      @networkterminationpoint = Networkterminationpoint.find_by_id(params[:id])
      if @networkterminationpoint != nil then
        if @networkterminationpoint.np_connections == nil then
          @other_np_connections = (Networkprovider.find(:all).map { |networkprovider| [networkprovider.name,networkprovider.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
        else
          @other_np_connections = ((Networkprovider.find(:all).map { |networkprovider| [networkprovider.name,networkprovider.id] }) - 
            (@networkterminationpoint.np_connections.map { |np_connection| [np_connection.networkprovider.name,np_connection.networkprovider.id] })).sort { |x,y| x[0].downcase <=> y[0].downcase }
        end
        @connection_types = get_list_of_connection_types
      end
      redirect_to :action => session[:page], :id => params[:id]
    else
      #render(:partial => "edit_datacenter_pane", :layout => false)
    end
  end      
  
  def select_networkprovider
    if params[:page] != nil then
      session[:page] = params[:page]
      @page = params[:page]
    end
    @previous_selection = session[:selected_networkprovider]
    session[:selected_networkprovider] = params[:id]
    if session[:page] == 'edit_latency_time' then
      @list_of_latency_times = get_list_of_latency_times_dependent
      render(:partial => 'latency_time_selector', :layout => false)
    else
      #render(:partial => "edit_datacenter_pane", :layout => false)
    end
  end  
  
  
  #-----REGION-----  
  def add_region
    redirect_to :action => 'edit_region', :id => 'NEW'
  end
  
  def delete_region
    begin
      delete_with_audits('Equinixregion',params[:id])
      session[:selected_region] = nil
    rescue Exception => error
      if error.to_s[0..26] != 'Mysql::Error: Cannot delete'
        flash[:notice] = "An unknown error occured: \"#{error}\""
      else
        flash[:notice] = "The Equinix Region <i>#{Equinixregion.find_by_id(params[:id]).region_name}</i> may not be deleted because it is the parent region of one or more Subregions. If you wish to delete this Region, you must first remove any association with this Region."
      end
    end
    redirect_to :action => 'edit_region', :id => session[:selected_region]
  end
  
  def save_region
    flash[:notice] = ''
    if params[:equinixregion][:region_name].blank? then
      flash[:notice] += "Region name cannot be blank. Renamed to '(No name)'.<br/>"
      params[:equinixregion][:region_name] = '(No name)' 
    end
    begin
      if params[:equinixregion][:id] == '' then
        @region = create_with_audits('Equinixregion',params[:equinixregion])
      else
        @region = update_with_audits('Equinixregion',params[:equinixregion])
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "An Equinix Region named '#{params[:equinixregion][:region_name]}' already exists! Use your internet browser's back button to recover changes."
      end
      redirect_to :action => 'edit_region', :id => nil and return
    end
    redirect_to :action => 'edit_region', :id => @region.id
  end
  
  def edit_region
    @subnav = "regions"
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_region'
    @selected_tab = params[:selected_tab]
    @selected_tab_row = params[:selected_tab_row]
    @page = session[:page]
    
    @search_region = session[:search_region]
    @selected_region = params[:id]
    session[:selected_region] = params[:id]
    session[:selected_region] = nil if session[:selected_region] == 'NEW'
    
    params[:id] = nil if !@current_user.can_view_page?('edit_region',params[:id])
    
    @list_of_regions = get_list_of_regions
    
    #string_to_hash = 'FxC0nn3ct' + 'eqx' + '24415244'
    #@show_password = string_to_hash.unpack('U'*string_to_hash.length).join
    
    if params[:id] == 'NEW' then
      @region = Equinixregion.new()
      @region.region_name = 'New Region'
      @modified = true
      @change_to_edit = true
    else
      @region = Equinixregion.find_by_id(params[:id])
      if @region != nil then
        news_associations = News2region.find(:all,:conditions => ["equinixregion_id = :id", {:id => @region.id}])
        @list_of_news = (news_associations.collect {|x| x.newsitem }).sort {|x,y| y.point_value_hottest <=> x.point_value_hottest }
        @center = {:lat => 0.0, :lon => 0.0}
        count_datacenters = 0
        @region.markets.each do |market| 
          market.datacenters.each do |datacenter|
            unless datacenter.networkterminationpoint.lat.blank? or datacenter.networkterminationpoint.lat == 0 or datacenter.networkterminationpoint.lon.blank? or datacenter.networkterminationpoint.lon == 0
              @center[:lat] += datacenter.networkterminationpoint.lat
              @center[:lon] += datacenter.networkterminationpoint.lon
              count_datacenters += 1
            end
          end unless market.datacenters.nil?
        end unless @region.markets.nil?
        @center[:lat] = @center[:lat]/count_datacenters unless count_datacenters == 0
        @center[:lon] = @center[:lon]/count_datacenters unless count_datacenters == 0
        if count_datacenters == 0 then
          @center[:message] = (@region.countries.collect {|country| "#{country.name}:#{if country.markets.nil? then '0' else country.markets.size end}"}).join(',')
          #@center[:message] = "#{(@region.markets.nil? ? 'nil' : @region.markets.size)},#{(@region.countries.nil? ? 'nil' : @region.countries.size)}"
        end
      end
      @modified = false
    end
  end
  #-----END REGION-----
  

  
  #-----NTP OWNER-----  
  def add_ntp_owner
    redirect_to :action => 'edit_ntp_owner', :id => 'NEW'
  end
  
  def delete_ntp_owner
    begin
      delete_with_audits('Networktermptowner',params[:id])
      session[:selected_networktermptowner_id] = nil
    rescue Exception => error
      if error.to_s[0..26] != 'Mysql::Error: Cannot delete'
        flash[:notice] = "An unknown error occured: \"#{error}\""
      else
        flash[:notice] = "The Network Termination Point Owner <i>#{Networktermptowner.find_by_id(params[:id]).name}</i> may not be deleted because it is the owner of one or more Network Termination Points. If you wish to delete this Owner, you must first remove any association with this Owner."
      end
    end
    redirect_to :action => 'edit_ntp_owner', :id => session[:selected_networktermptowner_id]
  end
  
  def save_ntp_owner
    flash[:notice] = ''
    if params[:networktermptowner][:name].blank? then
      flash[:notice] += "Owner name cannot be blank. Renamed to '(No name)'.<br/>"
      params[:networktermptowner][:name] = '(No name)' 
    end
    begin
      if params[:networktermptowner][:id] == '' then
        @ntp_owner = create_with_audits('Networktermptowner',params[:networktermptowner])
      else
        @ntp_owner = update_with_audits('Networktermptowner',params[:networktermptowner])
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "A Network Termination Point Owner named '#{params[:networktermptowner][:name]}' already exists! Use your internet browser's back button to recover changes."
      end
      redirect_to :action => 'edit_ntp_owner', :id => nil and return
    end
    redirect_to :action => 'edit_ntp_owner', :id => @ntp_owner.id
  end
  
  
  def edit_ntp_owner
    @subnav = "ntp_owners"
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_ntp_owner'
    @selected_tab = params[:selected_tab]
    @selected_tab_row = params[:selected_tab_row]
    @page = session[:page]
    
    params[:id] = nil if !@current_user.can_view_page?('edit_ntp_owner',params[:id])
    
    @selected_ntp_owner = params[:id]
    session[:selected_networktermptowner_id] = params[:id]
    session[:selected_networktermptowner_id] = nil if session[:selected_networktermptowner_id] == 'NEW'
    
    @list_of_ntp_owners = Networktermptowner.find(:all).map { |ntp_owner| [ntp_owner.name, "#{ntp_owner.id}"]}
    @list_of_ntp_owners.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    
    if params[:id] == 'NEW' then
      @ntp_owner = Networktermptowner.new()
      @ntp_owner.name = 'New Network Termination Point Owner'
      @modified = true
      @change_to_edit = true
    else
      @ntp_owner = Networktermptowner.find_by_id(params[:id])
      unless @ntp_owner.nil?
        news_associations = News2ntpowner.find(:all,:conditions => ["networktermptowner_id = :id", {:id => @ntp_owner.id}])
        @list_of_news = (news_associations.collect {|x| x.newsitem }).sort {|x,y| y.point_value_hottest <=> x.point_value_hottest }
      end
      @modified = false
    end
  end
  #-----END NTP OWNER-----
  
  
    
  
  
  #-----MARKET-----
  def add_market_ntp
    @market = Market.find_by_id(params[:market][:id])
    @change_to_edit = true
    @other_datacenters = get_list_of_datacenters(@market) 
    if params[:selected_datacenter] != nil and params[:selected_datacenter][:id] != nil then
      @ntp = Networkterminationpoint.find_by_id(params[:selected_datacenter][:id])
      if @ntp == nil then
        #@market_ntp_message = 'The Network Termination Point you selected could not be found.'
        render :partial => 'market_ntps' and return 
      end
      if @ntp.datacenterdetail == nil then
        if "#{@ntp.networktermpttype_id}" == '1' then
          #@market_ntp_message = "Datacenterdetail created."
          dc = create_with_audits('Datacenterdetail',{:networkterminationpoint_id => @ntp.id})
          dc.save!
        else
          #@market_ntp_message = 'The Network Termination Point you selected is not a datacenter!'
          render :partial => 'market_ntps' and return
        end
      end
      if @ntp != nil then
        #@market_ntp_message = "Nothing Happened." if @market_ntp_message.blank?
        #@market_ntp_message = "Datacenterdetail is blank!" if @ntp.datacenterdetail == nil
        #@ntp.datacenterdetail = Datacenterdetail.new({:networkterminationpoint_id => @ntp.id}) if @ntp.datacenterdetail == nil
        @ntp.datacenterdetail.market_id = @market.id
        @ntp.datacenterdetail.save!
        @market = Market.find_by_id(params[:market][:id])
        @other_datacenters = get_list_of_datacenters(@market) 
      end
    end
    render :partial => 'market_ntps' and return 
  end
  
  def remove_market_ntp
    @change_to_edit = true
    params[:selectedMarketNtps].join('').split(',').each do |ntp_id|
      ntp = Networkterminationpoint.find_by_id(ntp_id)
      ntp.datacenterdetail.market_id = nil
      ntp.datacenterdetail.save!
    end if !params[:selectedMarketNtps].blank?
    @market = Market.find_by_id(params[:market][:id])
    @other_datacenters = get_list_of_datacenters(@market)
    render :partial => 'market_ntps'
  end
  
  def add_market
    redirect_to :action => 'edit_market', :id => 'NEW'
  end
  
  def delete_market
    delete_with_audits('Market',params[:id])
    redirect_to :action => 'edit_market', :id => nil
  end
  
  def save_market
    flash[:notice] = ''
    if params[:market][:market_name].blank? then
      flash[:notice] += "Market name cannot be blank. Renamed to '(No name)'.<br/>"
      params[:market][:market_name] = '(No name)'
    end
    begin
      if params[:market][:id] == '' then
        @market = create_with_audits('Market',params[:market])
      else
        @market = update_with_audits('Market',params[:market])
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "A Market with the name '#{params[:market][:market_name]}' already exists! Use your internet browser's back button to recover changes."
      end
      redirect_to :action => 'edit_market', :id => nil and return
    end
    redirect_to :action => 'edit_market', :id => @market.id, :selected_tab_row => params[:current_tab_row], :selected_tab => params[:current_tab]
  end
  
  def edit_market
    @subnav = "markets"
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_market'
    @selected_tab = params[:selected_tab]
    @selected_tab_row = params[:selected_tab_row]
    @page = session[:page]
    
    session[:selected_market] = params[:id]
    @selected_region = session[:selected_region]
    @selected_country = session[:selected_country]
    @selected_market = session[:selected_market]
    
    if params[:id] != nil and params[:id] != '-1' then
      @market = Market.find_by_id(params[:id])
      if @market != nil then
        session[:selected_country] = "#{@market.country_id}" 
        @selected_country = session[:selected_country]
        session[:selected_region] = "#{Country.find_by_id(@selected_country).subregion.equinixregion.id}"
        @selected_region = session[:selected_region]
      end
    end
    
    @list_of_regions = get_list_of_regions
    @list_of_countries = get_list_of_countries
    @list_of_markets = get_list_of_markets
    
    if params[:id] == 'NEW' then
      @market = Market.new()
      @market.country_id = session[:selected_country]
      @market.market_name = "New Market"
      @market.market_description = "Description"
      session[:selected_market] = nil 
      @modified = true
      @change_to_edit = true
    else
      @market = Market.find_by_id(params[:id])
      if @market != nil then
        news_associations = News2market.find(:all,:conditions => ["market_id = :id", {:id => @market.id}])
        @list_of_news = (news_associations.collect {|x| x.newsitem }).sort {|x,y| y.point_value_hottest <=> x.point_value_hottest }
        @other_datacenters = get_list_of_datacenters(@market)
      else
        @other_datacenters = get_list_of_datacenters
      end
    end
  end
  #-----END MARKET-----
  
    
  
  
  #-----CAMPUS-----
  def add_campus_ntp
    @change_to_edit = true
    @campus = Campus.find_by_id(params[:campus][:id])
    @other_ntps = get_list_of_ntps_for_campus(@campus)
    if params[:selected_ntp] != nil and params[:selected_ntp][:id] != nil then
      @ntp = Networkterminationpoint.find_by_id(params[:selected_ntp][:id])
      unless @ntp.nil?
        @ntp.campus_id = @campus.id
        @ntp.save!
      end
    end
    render :partial => 'campus_ntps'
  end
  
  def remove_campus_ntp
    @change_to_edit = true
    params[:selectedCampusNtps].join('').split(',').each do |ntp_id|
      ntp = Networkterminationpoint.find_by_id(ntp_id)
      ntp.campus_id = nil
      ntp.save!
    end
    @campus = Campus.find_by_id(params[:campus][:id])
    @other_ntps = get_list_of_ntps_for_campus(@campus)
    render :partial => 'campus_ntps'
  end
  
  def add_campus
    redirect_to :action => 'edit_campus', :id => 'NEW'
  end
  
  def delete_campus
    delete_with_audits('Campus',params[:id])
    redirect_to :action => 'edit_campus', :id => nil
  end
  
  def save_campus
    flash[:notice] = ''
    if params[:campus][:name].blank? then
      flash[:notice] += "Campus name cannot be blank. Renamed to '(No name)'.<br/>"
      params[:campus][:name] = '(No name)'
    end
    begin
      if params[:campus][:id] == '' then
        @campus = create_with_audits('Campus',params[:campus])
      else
        @campus = update_with_audits('Campus',params[:campus])
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "A Campus with the name '#{params[:campus][:name]}' already exists! Use your internet browser's back button to recover changes."
      end
      redirect_to :action => 'edit_campus', :id => nil and return
    end
    redirect_to :action => 'edit_campus', :id => @campus.id
  end
  
  def edit_campus
    @subnav = "campuses"
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_campus'
    @page = session[:page]
    
    session[:selected_campus] = params[:id]
    @selected_networktermptowner_id = session[:selected_networktermptowner_id]
    @selected_campus = session[:selected_campus]
    
    @list_of_ntp_owners = get_list_of_ntp_owners
    @list_of_campuses = get_list_of_campuses
    @connection_types = get_list_of_connection_types 
    networktermptowner_ids = UserNtpOwner.find(:all, :conditions => "id = #{@selected_networktermptowner_id}").collect{|o| o.user_id}.uniq unless @selected_networktermptowner_id.nil?
    unless networktermptowner_ids.blank?
      @list_of_contacts = User.find(:all, :conditions => "id in (#{networktermptowner_ids.join(',')}) and active <> #{false}").collect{|u| [u.print_name, u.email, u.phone_number, u.id]}
    end  
    
    if params[:id] == 'NEW' then
      @campus = Campus.new
      @campus.networktermptowner_id = session[:selected_networktermptowner_id]
      @campus.name = "New Campus"
      session[:selected_campus] = nil 
      @modified = true
      @change_to_edit = true
    else
      @campus = Campus.find_by_id(params[:id])
      @other_ntps = get_list_of_ntps_for_campus(@campus)
    end
  end
  #-----END CAMPUS-----  
  
  
  
  
  
  
  #-----ACCOUNT MANAGEMENT-----  
  def account_executive_management
    @subnav == "accounts"
    session[:original_uri] = request.request_uri
    session[:page] = 'account_executive_management'
    user = User.find_by_id(session[:user_id])
    @list_of_pois = user.poiaccountexecutives.collect {|account| account.pointsofinterest }
    @list_of_pois.uniq!
    @list_of_equinix_ntps = (Networktermptowner.find_by_id(1).networkterminationpoints.collect {|x| [x.name,"#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
    @list_of_prospect_status_types = (Prospectstatustype.find(:all).collect {|x| [x.status_description,"#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
    @poi_connection_types = get_list_of_poi_connection_types
  end
  
  
  private 
  
  def check_editor_role
    return true
  end
  
  def get_list_of_countries
    if session[:selected_region] == nil or session[:selected_region] == '-1'
      list_of_countries = Country.find(:all).map { |country| [country.name, "#{country.id}"]}
    else
      list_of_countries = Array.new
      Equinixregion.find(session[:selected_region]).subregions.each do |subregion|
        subregion.countries.each { |country| list_of_countries <<  [country.name, "#{country.id}"]}
      end
    end
    return list_of_countries.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_pois    
    if session[:selected_region] == nil or session[:selected_region] == '-1' then
      list_of_pois = Pointsofinterest.find(:all).map { |poi| [poi.name, "#{poi.id}"]}
    else
      list_of_pois = Array.new
      Equinixregion.find(session[:selected_region]).subregions.each do |subregion|
        pois = Pointsofinterest.find(:all,:conditions => "unsubregion_id = #{subregion.id}")
        pois.each { |poi| list_of_pois << [poi.name, "#{poi.id}"] } if pois != nil
      end
    end
    return list_of_pois.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_subregions
    if session[:selected_region] == nil or session[:selected_region] == '-1'
      list_of_subregions = Unsubregion.find(:all).map { |subregion| [subregion.name, "#{subregion.id}"]}
    else
      list_of_subregions = Array.new
      Equinixregion.find(session[:selected_region]).subregions.each { |subregion| list_of_subregions << [subregion.name, "#{subregion.id}"]}
    end
    return list_of_subregions.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_ntp_owners
    list_of_ntp_owners = Networktermptowner.find(:all).map { |networktermptowner| [networktermptowner.name, "#{networktermptowner.id}"]}
    return list_of_ntp_owners.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_campuses(ntp = nil)
    if ntp == nil then
      selected_networktermptowner_id = session[:selected_networktermptowner_id]
    else
      selected_networktermptowner_id = ntp.networktermptowner_id
    end
    return nil if selected_networktermptowner_id == nil or selected_networktermptowner_id == '-1'
    
    list_of_campuses = Array.new
    networktermptowner_id = Networktermptowner.find_by_id(selected_networktermptowner_id)
    return nil if networktermptowner_id == nil or networktermptowner_id.campuses == nil 
    networktermptowner_id.campuses.each { |campus| list_of_campuses << ["#{campus.name}", "#{campus.id}"] }
    
    return list_of_campuses.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_ntps_for_campus(campus = nil)
    return nil if campus == nil or campus.networktermptowner_id == nil
    list_of_ntps = Array.new
    Networktermptowner.find_by_id(campus.networktermptowner_id).networkterminationpoints.each { |ntp| list_of_ntps << ["#{ntp.name}", "#{ntp.id}"] }
    return list_of_ntps.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_networktermpttype_ids
    list_of_networktermpttype_ids = Networktermpttype.find(:all).map { |networktermpttype_id| [networktermpttype_id.name, "#{networktermpttype_id.id}"]}
    return list_of_networktermpttype_ids.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_networkproviders
    if session[:page] == 'edit_networkprovider'
      networkproviders = @current_user.viewable_objects_on_page(session[:page])
    else
      networkproviders = @current_user.viewable_objects_on_page('edit_networkprovider')
    end
    #networkproviders = Networkprovider.find(:all,:conditions => ["id in (1,2,3)"])
    list_of_networkproviders = networkproviders.collect {|obj| [obj.name,"#{obj.id}"]}
    return list_of_networkproviders.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_services_dependent
    return nil if session[:selected_poi] == nil or session[:selected_poi] == '-1'
    
    list_of_services = Array.new
    Pointsofinterest.find(session[:selected_poi]).services.each { |service| list_of_services << ["#{service.name}#{" (#{service.service_acronym})" if !service.service_acronym.blank? }", "#{service.id}"] }
    
    return list_of_services.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_ntps_dependent
    return nil if session[:selected_country] == nil or session[:selected_country] == '-1' or session[:selected_networktermpttype_id] == nil or session[:selected_networktermpttype_id] == '-1'
    
    list_of_ntp_objs = @current_user.viewable_objects_on_page(session[:page])
    
    list_of_ntp_objs.delete_if {|obj| "#{obj.networktermptowner_id}" != session[:selected_networktermptowner_id] or "#{obj.country_id}" != session[:selected_country] or "#{obj.networktermpttype_id}" != session[:selected_networktermpttype_id]}
    
    list_of_ntps = list_of_ntp_objs.collect {|obj| [obj.name,"#{obj.id}"]}

=begin
    if @current_user.is_equinix_user? then
      list_of_ntps = Array.new
      if session[:selected_networktermptowner_id] == nil or session[:selected_networktermptowner_id] == '-1' then
        Networkterminationpoint.find(:all, :conditions => ["networktermptowner_id is null and country_id = :country_id and networktermpttype_id = :networktermpttype_id",
                                                          {:country_id => session[:selected_country], :networktermpttype_id => session[:selected_networktermpttype_id]}]).each do |networkterminationpoint| 
          list_of_ntps << [networkterminationpoint.name, "#{networkterminationpoint.id}"] if "#{networkterminationpoint.country_id}" == session[:selected_country] 
        end
      else
        Networkterminationpoint.find(:all, :conditions => ["networktermptowner_id = :networktermptowner_id and country_id = :country_id and networktermpttype_id = :networktermpttype_id", 
                                                          {:networktermptowner_id => session[:selected_networktermptowner_id], 
                                                           :country_id => session[:selected_country], 
                                                           :networktermpttype_id => session[:selected_networktermpttype_id]}]).each do |networkterminationpoint| 
          list_of_ntps << [networkterminationpoint.name, "#{networkterminationpoint.id}"] if "#{networkterminationpoint.country_id}" == session[:selected_country]
        end
      end
    else
      return Array.new if @current_user.networktermptowners == nil
      list_of_ntps = Array.new
      @current_user.networktermptowners.each do |ntp_owner|
        ntp_owner.networkterminationpoints.each do |ntp|
          list_of_ntps << [ntp.name, "#{ntp.id}"] if "#{ntp.country_id}" == session[:selected_country] \
            and ( "#{ntp.networktermptowner_id}" == session[:selected_networktermptowner_id] \
            or (session[:selected_networktermptowner_id] == '-1' and ntp.networktermptowner_id == nil) \
            or (session[:selected_networktermptowner_id] == nil and ntp.networktermptowner_id == nil)) \
            and "#{ntp.networktermpttype_id}" == session[:selected_networktermpttype_id]
        end
      end
    end
=end
    return list_of_ntps.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_pois_dependent(region)
    return nil if region.nil? or region == '-1'
    subregions = Equinixregion.find(region).subregions.collect{|s| s.id}
    if @current_user.is_equinix_user?
      list_of_pois = Pointsofinterest.find(:all, :conditions => "unsubregion_id in (#{subregions.join(',')})", :order => "name").collect{|poi| [poi.name, poi.id]}
    else
      list_of_pois = @current_user.pointsofinterests.find(:all, :conditions => "unsubregion_id in (#{subregions.join(',')})", :order => "name").collect{|poi| [poi.name, poi.id]} if @current_user.pointsofinterests.nil?
    end
    return list_of_pois
  end
  
  
  def get_list_of_latency_times_dependent
    return nil if session[:selected_networkprovider] == nil or session[:selected_networkprovider] == '-1'
    
    list_of_latency_times = Array.new
    Networkprovider.find(session[:selected_networkprovider]).connections.each do |connection|
      list_of_latency_times << ["#{connection.np2ntpA.networkterminationpoint.name} (#{connection.np2ntpA.connectiontype.name if connection.np2ntpA.connectiontype != nil}) <=> #{connection.np2ntpB.networkterminationpoint.name} (#{connection.np2ntpB.connectiontype.name})", "#{connection.id}"]
    end
    
    return list_of_latency_times.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_a_np2ntps(selected_np2ntp)
    list_of_np2ntps = Array.new
    results = Networkprovider.find(session[:selected_networkprovider]).ntp_connections
    np_connections_size = results.size 
    results.each do |connection|
      if "#{connection.id}" == "#{selected_np2ntp}" or Latencytime.find(:all, 
                                                              :conditions => ["networkprovider_id = :networkprovider_id and (a_np2ntp_id = :np2networkterminationpoint_id or b_np2ntp_id = :np2networkterminationpoint_id)", 
                                                                             {:networkprovider_id => session[:selected_networkprovider], :np2networkterminationpoint_id => connection.id}]).size != (np_connections_size-1) then
        list_of_np2ntps << ["#{connection.networkterminationpoint.name} (#{connection.connectiontype.name if connection.connectiontype != nil})", "#{connection.id}"]
      end
    end
    return list_of_np2ntps.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_b_np2ntps (np2ntp_id_a, np2ntp_id_b)
    list_of_np2ntps = Array.new
    results = Networkprovider.find(session[:selected_networkprovider]).ntp_connections
    results.each do |connection|
      if ("#{connection.id}" != "#{np2ntp_id_a}") and 
        (connection.id == np2ntp_id_b or Latencytime.find(:all, 
                                                          :conditions => ["networkprovider_id = :networkprovider_id and ((a_np2ntp_id = :a_np2ntp_id and b_np2ntp_id = :b_np2ntp_id) or (a_np2ntp_id = :b_np2ntp_id and b_np2ntp_id = :a_np2ntp_id))", 
                                                                          {:networkprovider_id => session[:selected_networkprovider], :a_np2ntp_id => np2ntp_id_a, :b_np2ntp_id => connection.id}]).size == 0) then
        list_of_np2ntps << ["#{connection.networkterminationpoint.name} (#{connection.connectiontype.name if connection.connectiontype != nil})", "#{connection.id}"]
      end
    end
    return list_of_np2ntps.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_markets
    return nil if session[:selected_country] == nil or session[:selected_country] == '-1'
    list_of_markets = Array.new
    markets = Market.find(:all,:conditions => ["country_id = :country_id", {:country_id => session[:selected_country]}])
    markets.each do |market|
      list_of_markets << ["#{market.market_name}","#{market.id}"]
    end if markets != nil
    return list_of_markets.sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_datacenters(market = nil)
    base_lat_lon = get_center_of_market_map(market) if market != nil
    list_of_datacenters = Array.new
    datacenters = Networkterminationpoint.find(:all,:conditions => ["country_id = :country_id and networktermpttype_id = '1'", {:country_id => session[:selected_country]}])
    datacenters.sort! { |x,y| get_miles_distance(x,base_lat_lon) <=> get_miles_distance(y,base_lat_lon) } if market != nil
    datacenters.each do |datacenter|
      if datacenter.datacenterdetail == nil or "#{datacenter.datacenterdetail.market_id}" != "#{session[:selected_market]}" then
        if datacenter.datacenterdetail == nil or datacenter.datacenterdetail.market == nil then
          list_of_datacenters << ["#{datacenter.name}","#{datacenter.id}"]
        else
          list_of_datacenters << ["#{datacenter.name} - Current Market: #{datacenter.datacenterdetail.market.market_name}","#{datacenter.id}"]
        end
      end
    end
    list_of_datacenters.sort! { |x,y| x[0].downcase <=> y[0].downcase } if market == nil
    return list_of_datacenters
  end
  
  
  def shorten_to(theText, toLength)
    return theText[0,theText.length] if theText.length < toLength
    "#{theText[0,toLength]}..."
  end
  
  
  def get_list_of_connection_types
    (Connectiontype.find(:all).map { |type| ["#{type.name} - #{type.type_description}", type.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
    #(Connectiontype.find(:all).map { |type| ["#{type.name}", type.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  
  def get_list_of_equinix_users
    user_networktermptowner_ids = UserNtpOwner.find(:all, :conditions => "networktermptowner_id = #{Networktermptowner.find_by_name('Equinix').id}").collect{|u| u.user_id}
    equinix_users = User.find(:all, :conditions => "id in (#{user_networktermptowner_ids.join(',')})", :order => 'last_name, first_name').collect { |user| ["#{user.print_name}", user.id] }
    return equinix_users
  end
  
  def get_list_of_poi_connection_types
    (Poiconnectiontype.find(:all).map { |type| ["#{type.name} - #{type.description}", type.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def get_list_of_quality_types
    ((Qualitytype.find(:all).map { |type| [type.quality_type, "#{type.id}"] }).sort { |x,y| x[0].downcase <=> y[0].downcase }).insert(0,[' ',' '])
  end
  
  def get_list_of_ups_system_types
    ((Upssystemtype.find(:all).map { |type| [type.ups_system_type, "#{type.id}"] }).sort { |x,y| x[0].downcase <=> y[0].downcase }).insert(0,[' ','0'])
  end
  
  def get_list_of_sprinkler_types
    ((Sprinklertype.find(:all).map { |type| [type.sprinkler_type, "#{type.id}"] }).sort { |x,y| x[0].downcase <=> y[0].downcase }).insert(0,[' ',' '])
  end
  
  def get_list_of_regions
    (Equinixregion.find(:all).map { |region| [region.region_name, "#{region.id}"]}).sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def networktermptowner_id_has_ntp_as_child(networktermptowner_id, networkterminationpoint_id)
    networktermptowner_id = Networktermptowner.find_by_id(networktermptowner_id);
    return false if networktermptowner_id == nil
    networktermptowner_id.networkterminationpoints.each do |ntp|
      return true if "#{ntp.id}" == "#{networkterminationpoint_id}"
    end if networktermptowner_id.networkterminationpoints != nil
    return false
  end
  
  def f_to_c(f)
    return (((5.0/9)*(f-32))*100).round/100.0
  end

  def c_to_f(c)
    return (((9.0/5)*c+32)*100).round/100.0
  end

  def km_to_miles(km)
    return ((km*0.6214)*100).round/100.0
  end

  def mile_to_km(mile)
    return ((mile / 0.6214)*100).round/100.0
  end

  def m_to_ft(m)
    return ((m*3.281)*100).round/100.0
  end
  
  def ft_to_m(ft)
    return ((ft*0.3048)*100).round/100.0
  end
  
  def m2_to_ft2(m2)
    return ((m2*10.76)*100).round/100.0
  end
  
  def ft2_to_m2(ft2)
    return ((ft2*0.09294)*100).round/100.0
  end
  
  def m2r_to_ft2r(m2)
    return ((m2*(1/10.76))*100).round/100.0
  end
  
  def ft2r_to_m2r(ft2)
    return ((ft2*(1/0.09294))*100).round/100.0
  end
  
  def yard_to_m(yard)
    return ((yard*0.9144)*100).round/100.0
  end
  
  def m_to_yard(m)
    return ((m*3.281)*100).round/100.0
  end
  
  def gal_to_lit(gal)
    return ((gal/4.546)*100).round/100.0
  end
  
  def lit_to_gal(lit)
    return ((lit*4.546)*100).round/100.0
  end  
  
  def get_list_of_np_contacts(networkprovider_id)
    list_of_users = Array.new
    np = Networkprovider.find(networkprovider_id)
    np.users.each do |user| 
      phone = " [#{user.phone_number}]" unless user.phone_number.blank?
      list_of_users << ["#{user.print_name} (#{user.email})#{phone}","#{user.id}"]
    end
    return nil if list_of_users.size == 0
    return list_of_users.insert(0,['None',''])
  end
  
  def set_poi_vars
    @parent_pois = Pointsofinterest.find(:all, :conditions => "id <> #{@pointsofinterest.id}", :order => "name").collect {|poi| [poi.name, poi.id]}
    @poi_types = Poitype.find(:all, :order => "name").collect { |type| [type.name,type.id] }
    region = @pointsofinterest.subregion.equinixregion
    @subregions = region.subregions.find(:all, :order => 'name').collect{|subregion| [subregion.name,subregion.id]}
    @poi_connection_types = Poiconnectiontype.find(:all, :order => 'name').collect { |type| ["#{type.name} - #{type.description}", type.id] }
    @list_of_news = @pointsofinterest.newsitems
    @list_of_countries = Country.find(:all, :order => 'name').collect {|c| [c.name,c.id]}
    @list_of_equinix_users = get_list_of_equinix_users
    @list_of_equinix_ntps = Networktermptowner.find_by_name("Equinix").networkterminationpoints.find(:all, :order => 'networkterminationpoints.name').collect {|ntp| [ntp.name,ntp.id]}
    @list_of_prospect_status_types = Prospectstatustype.find(:all, :order => 'status_description').collect {|t| [t.status_description,t.id]}
    if @pointsofinterest.networkterminationpoints.blank?
      @other_ntp_connections = Networkterminationpoint.find(:all, :order => 'name').collect {|ntp| [ntp.name,ntp.id]}
    else  
      @other_ntp_connections = @pointsofinterest.networkterminationpoints.find(:all, :order => 'name').collect {|ntp| [ntp.name,ntp.id]} 
    end
    if @pointsofinterest.preferred_nps.blank?
      @other_preferred_nps = Networkprovider.find(:all, :order => 'name').collect { |np| [np.name,np.id] }   
    else  
      @other_preferred_nps = @pointsofinterest.networkproviders.find(:all, :order => 'name').collect { |np| [np.name,np.id] } 
    end
  end  
  
  def set_new_poi_vars
    @parent_pois = Pointsofinterest.find(:all, :order => "name").collect {|poi| [poi.name, poi.id]}
    @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
    @poi_types = Poitype.find(:all, :order => "name").collect { |type| [type.name, type.id] } 
  end  
  
  def set_region_map_vars(region)
    region.markets.each do |market|
      @market_circles << create_market_circles(market)
    end
  end
  
  def create_market_circles(market)
    center = get_center_of_market_map(market)
    market.datacenters.each do |datacenter|
      
    end
  end
end
