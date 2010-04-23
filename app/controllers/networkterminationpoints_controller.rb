require "pdf/writer"
require "pdf/simpletable"

class NetworkterminationpointsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  before_filter :variables
  
  def index
    redirect_to :action => 'edit'
  end
  
  def new
    @networkterminationpoint = Networkterminationpoint.new
    @datacenterdetail = Datacenterdetail.new
    set_new_vars
  end 
  
  def error
    raise RuntimeError, "Generating an error"
  end
  
  def show_countries
    unless params[:region_id].blank?
      subregion_list = Equinixregion.find(params[:region_id]).subregions.collect{|sub| sub.id}
      @list_of_countries = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|c| [c.name, c.id]}
    else  
      @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    end  
    render :partial => 'show_countries'
  end
  
  def show_campuses
    unless params[:networktermptowner_id].blank?
      @list_of_campuses = Campus.find(:all, :conditions => "networktermptowner_id = #{params[:networktermptowner_id]}", :order => 'name').collect{|c| [c.name, c.id]}
    else  
      @list_of_campuses = Campus.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    end  
    render :partial => 'show_campuses'
  end
  
  def show_markets
    unless params[:country_id].blank?
      @list_of_markets = Market.find(:all, :conditions => "country_id = #{params[:country_id]}", :order => 'market_name').collect{|m| [m.market_name, m.id]}
    else  
      @list_of_markets = Market.find(:all, :order => 'market_name').collect{|m| [m.market_name, m.id]}
    end
    render :partial => 'select_market'
  end
  
  def create
    @networkterminationpoint = Networkterminationpoint.new(params[:networkterminationpoint])
    if @networkterminationpoint.is_datacenter?
      do_unit_calculations(params[:datacenterdetail])
      @datacenterdetail = Datacenterdetail.new(params[:datacenterdetail]) 
      @datacenterdetail.networkterminationpoint = @networkterminationpoint 
    end
    if @networkterminationpoint.save
      if @datacenterdetail && @datacenterdetail.save 
        Audittrail.new.create_new_audit(@current_user, "Datacenterdetail", @datacenterdetail.id)
      end  
      Audittrail.new.create_new_audit(@current_user, "Networkterminationpoint", @networkterminationpoint.id)
      flash[:notice] = "Network Termination Point was successfully created."
      redirect_to :action => 'edit', :id => @networkterminationpoint.id
    else
      set_new_vars
      unless params[:networkterminationpoint][:country_id].blank?
        region = Country.find(params[:networkterminationpoint][:country_id]).subregion.equinixregion
        @selected_region = region.id  
        subregion_list = region.subregions.collect{|sub| sub.id}
        @countries = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|c| [c.name, c.id]}
      else
        @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
      end    
      render :action => 'new'
    end    
  end  
  
  def edit
    session[:page] = 'edit_ntp'
    @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
    @list_of_networktermpttype_ids = Networktermpttype.find(:all, :order => 'name').collect { |t| [t.name, t.id]}
    @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    @list_of_ntps = Networkterminationpoint.find(:all, :order => 'name').collect{|ntp| [ntp.name, ntp.id]}
    if params[:id]
      @networkterminationpoint = Networkterminationpoint.find(params[:id])
      set_vars
      @selected_ntp = @networkterminationpoint.id
    end  
  end  
  
  def get_ntps
    @list_of_ntps = Networkterminationpoint.find(:all, :conditions => conditions, :order => 'name').collect{|ntp| [ntp.name,ntp.id]} 
		render :partial => 'ntp_selector'
  end 
   
  def show
    unless params[:ntp_id] == '0'
      @networkterminationpoint = Networkterminationpoint.find(params[:ntp_id])
      set_vars
    end
    render :partial => "edit"
  end
  
  def show_market
    @market = Market.find_by_id(params[:market_id])
    unless @market.nil?
      @market_competitors = @market.datacenters.sort {|x,y| x.networkterminationpoint.name.downcase <=> y.networkterminationpoint.name.downcase }
      @networkterminationpoint = Networkterminationpoint.find(params[:ntp_id])
    end
    render :partial => 'markets'
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
  
  def update
    @networkterminationpoint = Networkterminationpoint.find(params[:id])
    @datacenterdetail = @networkterminationpoint.datacenterdetail
    do_unit_calculations(params[:datacenterdetail]) if params[:datacenterdetail]
    networkterminationpoint_changes = get_changes(@networkterminationpoint,params[:networkterminationpoint])
    datacenter_changes = get_changes(@datacenterdetail,params[:datacenterdetail]) unless @datacenterdetail.nil?
    if @networkterminationpoint.update_attributes(params[:networkterminationpoint])
      if @networkterminationpoint.is_datacenter? 
        if @datacenterdetail && @datacenterdetail.update_attributes(params[:datacenterdetail])
          Audittrail.new.create_update_audit(@current_user, "Datacenterdetail", @datacenterdetail.id,datacenter_changes)
        end
      else
        Audittrail.new.create_destroy_audit(@current_user, "Datacenterdetail", @datacenterdetail.id) if @datacenterdetail
      end
      Audittrail.new.create_update_audit(@current_user, "Networkterminationpoint", @networkterminationpoint.id,networkterminationpoint_changes)
      flash[:notice] = "Point of Interest was successfully updated."
      redirect_to :action => 'edit', :id => @networkterminationpoint.id
    else
      @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
      @change_to_edit = true
      @selected_tab = params[:selected_tab]
      set_vars
      render :action => 'edit', :id => @networkterminationpoint.id
    end
    
    
    campus = Campus.find_by_id(params[:networkterminationpoint][:campus_id])
    unless campus.nil?
      campus_ntp_ids = (campus.networkterminationpoints.collect {|ntp| ntp.id})
      params[:campus_connection].each_pair do |key,val|
        min_id, max_id = key.split('_')
        min_id, max_id = min_id.to_i, max_id.to_i
        type = val.to_i
        latency = params[:campus_latency][key].to_f
        latency = "" if params[:campus_latency][key].blank?
        connection = CampusNtp2ntp.find(:first,:conditions => ["a_networkterminationpoint_id = :a_ntp_id and b_networkterminationpoint_id = :b_ntp_id", {:a_ntp_id => min_id, :b_ntp_id => max_id}])
        if connection.nil? then
          if campus_ntp_ids.include?(min_id) and campus_ntp_ids.include?(max_id) then
            create_with_audits('CampusNtp2ntp',{:a_networkterminationpoint_id => min_id, :b_networkterminationpoint_id => max_id, :campus_access_type_id => type, :latency_time => latency})
          end
        else
          if min_id == @networkterminationpoint.id or max_id == @networkterminationpoint.id then
            if not campus_ntp_ids.include?(min_id) or not campus_ntp_ids.include?(max_id) then
              delete_with_audits('CampusNtp2ntp',connection.id)
            elsif connection.campus_access_type_id != type or connection.latency_time != latency then
              update_with_audits('CampusNtp2ntp',{:id => connection.id, :campus_access_type_id => type, :latency_time => latency})
            end
          end
        end
      end unless params[:campus_connection].nil?
    end
  end  
  
  def destroy
    @networkterminationpoint = Networkterminationpoint.find_by_id(params[:id])
    Audittrail.new.create_destroy_audit(@current_user, "Networkterminationpoint", @networkterminationpoint.id)
    Audittrail.new.create_destroy_audit(@current_user, "Datacenterdetail", @networkterminationpoint.datacenterdetail.id) if @networkterminationpoint.datacenterdetail
    @networkterminationpoint.destroy
    flash[:notice] = 'Network Termination Point successfully destroyed'
    redirect_to :action => 'edit'
  end
  
  def populate_other_unit(parms,name,metric,british,baseField = nil)
    if @current_user.unit_preference == 'B' then
      if parms["#{name}_british"] != nil and !parms["#{name}_british"].blank? then
        if parms["#{name}_metric"] == nil then 
          if baseField != nil
            absolute = parms["#{name}_british"].to_i + parms["#{baseField}_british"].to_i
            parms["#{name}_metric"] = (eval("#{british}_to_#{metric}(absolute)")*100)/100 
            parms["#{name}_metric"] = parms["#{name}_metric"] - parms["#{baseField}_metric"]
          else
            parms["#{name}_metric"] = (eval("#{british}_to_#{metric}(parms['#{name}_british'].to_i)")*100)/100
          end
        end
      else
        parms["#{name}_metric"] = ''
      end
    else
      if parms["#{name}_metric"] != nil and !parms["#{name}_metric"].blank? then
        if parms["#{name}_british"] == nil then
          if baseField != nil
            absolute = parms["#{name}_metric"].to_i + parms["#{baseField}_metric"].to_i
            parms["#{name}_british"] = (eval("#{metric}_to_#{british}(parms['#{name}_metric'].to_i)")*100)/100
            parms["#{name}_british"] = parms["#{name}_british"] - parms["#{baseField}_british"]
          else
            parms["#{name}_british"] = (eval("#{metric}_to_#{british}(parms['#{name}_metric'].to_i)")*100)/100
          end
        end
      else
        parms["#{name}_british"] = ''
      end 
    end
  end
  
  def do_unit_calculations(parms)
    populate_other_unit(parms,'gross_floor_capacity','m2','ft2')
    populate_other_unit(parms,'floor_capacity','m2','ft2')
    populate_other_unit(parms,'distance_to_bus','m','yard')
    populate_other_unit(parms,'distance_to_train','m','yard')
    populate_other_unit(parms,'power_density','m2r','ft2r')
    populate_other_unit(parms,'diesel_storage','lit','gal')
    populate_other_unit(parms,'temp_control','c','f')
    populate_other_unit(parms,'temp_control_plus_minus','c','f','temp_control')
    populate_other_unit(parms,'water_capacity','lit','gal')
  end

  private
    def get_list_of_ntps_dependent(country, networktermpttype)
      return nil if session[:selected_country] == nil or session[:selected_country] == '-1' or session[:selected_networktermpttype_id] == nil or session[:selected_networktermpttype_id] == '-1'
      list_of_ntp_objs = @current_user.viewable_objects_on_page(session[:page])
      list_of_ntp_objs.delete_if {|obj| "#{obj.networktermptowner_id}" != session[:selected_networktermptowner_id] or "#{obj.country_id}" != session[:selected_country] or "#{obj.networktermpttype_id}" != session[:selected_networktermpttype_id]}
      list_of_ntps = list_of_ntp_objs.collect {|obj| [obj.name,"#{obj.id}"]}
      return list_of_ntps.sort { |x,y| x[0].downcase <=> y[0].downcase }
    end
    
    def variables
      @subnav = "ntps"
    end  
    
    def set_vars
      @list_of_n_plus = [['N+1','1'],['N+2','2'],['N+3','3'],['N+4','4']]
      @connection_types = Connectiontype.find(:all, :order => 'name').collect { |t| ["#{t.name} - #{t.type_description}", t.id] }
      @poi_connection_types = Poiconnectiontype.find(:all, :order => 'name').collect { |t| ["#{t.name} - #{t.description}", t.id] }
      @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}

      if @networkterminationpoint
        #grouped_audits = get_audits_for_object('Networkterminationpoint',@networkterminationpoint.id)
        #@history_items = combine_grouped_audits(@networkterminationpoint,grouped_audits)
        @list_of_markets = Market.find(:all, :conditions => "country_id = #{@networkterminationpoint.country_id}", :order => 'market_name').collect{|m| [m.market_name, m.id]}
        @datacenterdetail = @networkterminationpoint.datacenterdetail
        @market = @datacenterdetail.market if @datacenterdetail
        @market_competitors = @market.datacenters.find(:all, :include => :networkterminationpoint, :order => 'networkterminationpoints.name') if @market
        
        np_connections = @networkterminationpoint.networkproviders.collect{|np| np.id}
        if np_connections.empty?
          @other_np_connections = Networkprovider.find(:all, :order => 'name').collect{|np| [np.name,np.id]}
        else
          @other_np_connections = Networkprovider.find(:all, :conditions => "id not in (#{np_connections.join(',')})", :order => 'name').collect{|np| [np.name,np.id]}
        end
        
        poi_connections = @networkterminationpoint.pois.collect{|poi| poi.id}
        if poi_connections.empty? or true then # Always show all ntps. Decision made to show all because multiple connections may exist for the same poi/ntp pair if type is different
          @other_poi_connections = Pointsofinterest.find(:all, :order => 'name').collect {|poi| [poi.name,poi.id]}  
        else
          @other_poi_connections = Pointsofinterest.find(:all, :conditions => "id not in (#{poi_connections.join(',')})", :order => 'name').collect{|poi| [poi.name,poi.id]}  
        end
        
      end
      @datacenterdetail = Datacenterdetail.new if @datacenterdetail.nil?
    end  
    
    def set_new_vars
      @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
      @list_of_n_plus = [['N+1','1'],['N+2','2'],['N+3','3'],['N+4','4']]
      @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
      @list_of_markets = Market.find(:all, :order => 'market_name').collect{|m| [m.market_name, m.id]}
    end
    
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
    
end
