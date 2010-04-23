class PointsofinterestsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  before_filter :variables
  
  def index
    redirect_to :action => 'edit'
  end  
  
  def new
    @pointsofinterest = Pointsofinterest.new
    @subregions = Unsubregion.find(:all, :order => 'name').collect{|sub| [sub.name, sub.id]}
    set_new_poi_vars
  end
  
  def create
    @pointsofinterest = Pointsofinterest.new(params[:pointsofinterest])
    if @pointsofinterest.save
      Audittrail.new.create_new_audit(@current_user, "Pointsofinterest", @pointsofinterest.id)
      flash[:notice] = "Point of Interest was successfully created."
      redirect_to :action => 'edit', :id => @pointsofinterest.id
    else
      set_new_poi_vars
      unless params[:pointsofinterest][:unsubregion_id].blank?
        @selected_subregion = Unsubregion.find(params[:pointsofinterest][:unsubregion_id])
        @selected_region = @selected_subregion.equinixregion_id
        @subregions = @selected_subregion.equinixregion.subregions.collect{|sub| [sub.name, sub.id]}
      else
        @subregions = Unsubregion.find(:all, :order => 'name').collect{|sub| [sub.name, sub.id]}
      end    
      render :action => 'new'
    end
  end
  
  def edit
    session[:page] = 'edit_poi'
    if params[:id] and !params[:id].blank?
      @pointsofinterest = Pointsofinterest.find_by_id(params[:id])
      if @pointsofinterest then
        params[:theId] = @pointsofinterest.id
      end
      set_poi_vars
      unless @pointsofinterest.blank?
        @selected_region = @pointsofinterest.subregion.equinixregion_id
        subregion_list = Equinixregion.find(@selected_region).subregions.collect{|sub| sub.id}
        @list_of_pois = Pointsofinterest.find(:all,:conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|poi| [poi.name,poi.id] } 
        @selected_poi = @pointsofinterest.id
        @selected_tab = (params[:selected_tab])?(params[:selected_tab]):('1')
      end
    end 
    @list_of_pois = Pointsofinterest.find(:all, :order => 'name').collect{|poi| [poi.name,poi.id] }
    @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
  end
   
  def select_poi
    if params[:select_poi].blank? or params[:select_poi] == "0"
      redirect_to :action => 'edit', :id => nil
    else
      redirect_to :action => 'edit', :id => params[:select_poi]
    end
  end
   
  def show
    unless params[:poi_id] == '0'
      @pointsofinterest = Pointsofinterest.find(params[:poi_id])
      set_poi_vars
    end
    render :partial => "edit_poi"
  end
  
  def update
    @pointsofinterest = Pointsofinterest.find_by_id(params[:id])
    poi_changes = get_changes(@pointsofinterest,params[:pointsofinterest])
    if @pointsofinterest.update_attributes(params[:pointsofinterest]) then
      unless params[:provider_categories].nil?
        new_categories = (params[:provider_categories].collect {|provider_category_type_id| provider_category_type_id.to_i}).delete_if {|cat| cat == 0}
        current_categories = @pointsofinterest.provider_categories.collect {|category| category.id}
        (new_categories - current_categories).each do |category_id|
          create_with_audits('PointsofinterestProviderCategory',{:pointsofinterest_id => @pointsofinterest.id, :pointsofinterest_provider_category_type_id => category_id})
        end
        (current_categories - new_categories).each do |category_id|
          category = PointsofinterestProviderCategory.find(:first,:conditions => "pointsofinterest_id = #{@pointsofinterest.id} and pointsofinterest_provider_category_type_id = #{category_id}")
          delete_with_audits('PointsofinterestProviderCategory',category.id)
        end
      end
      Audittrail.new.create_update_audit(@current_user, "Pointsofinterest", @pointsofinterest.id,poi_changes)
      flash[:notice] = "Point of Interest was successfully updated."
      redirect_to :action => 'edit', :id => @pointsofinterest.id
    else
      @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
      @change_to_edit = true
      @selected_tab = params[:selected_tab]
      set_poi_vars
      render :action => 'edit', :id => @pointsofinterest.id
    end    
  end
  
  def select_poi_region
    unless params[:region_id] == '0'
      subregion_list = Equinixregion.find(params[:region_id]).subregions.collect{|sub| sub.id}
      @list_of_pois = Pointsofinterest.find(:all,:conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|poi| [poi.name,poi.id] }
      @selected_poi = params[:poi_id] if !params[:poi_id].blank?
      @selected_tab = (params[:selected_tab].blank? ? '1' : params[:selected_tab])
    else
      @list_of_pois = Pointsofinterest.find(:all, :order => 'name').collect{|poi| [poi.name,poi.id] }  
    end
    render :partial => 'select_poi'
  end  
  
  def show_subregions
    unless params[:region_id].blank?
      @subregions = Equinixregion.find(params[:region_id]).subregions.collect{|sub| [sub.name, sub.id]}
    else
      @subregions = Unsubregion.find(:all, :order => 'name').collect{|sub| [sub.name, sub.id]}
    end
    render :partial => 'show_subregions'
  end
  
  def destroy
    @pointsofinterest = Pointsofinterest.find(params[:id])
    Audittrail.new.create_destroy_audit(@current_user, "Pointsofinterest", @pointsofinterest.id)
    @pointsofinterest.destroy
    flash[:notice] = "Point of Interest successfully destroyed"
    redirect_to :action => 'edit'
  end
  
  
  # Move the following actions in their own controllers
  def add_preferred_np
    begin
      fieldValues = {:pointsofinterest_id => params[:poi][:id], :networkprovider_id => params[:selected_np][:id]}
      @preferred_np = create_with_audits('Poipreferrednp',fieldValues)
    rescue Exception => error
      flash[:notice] += "An unknown error occured: \"#{error}\""
      redirect_to :action => 'edit', :id => params[:poi][:id] and return
    end
    @pointsofinterest = Pointsofinterest.find_by_id(params[:poi][:id])
    if @pointsofinterest.networkproviders.blank?
      @other_preferred_nps = Networkprovider.find(:all, :order => 'name').map { |np| [np.name,np.id] }
    else
      @other_preferred_nps = Networkprovider.find(:all, :conditions => "id not in (#{(@pointsofinterest.networkproviders.collect {|np| np.id}).join(',')})", :order => 'name').collect { |np| [np.name,np.id] }    
    end
    @change_to_edit = true
    render :partial => "poi_preferred_nps"
  end
  
  def remove_preferred_np
    @change_to_edit = true
    begin
      params[:selectedPreferredNps].join('').split(',').each do |preferred_np_id|
        delete_with_audits('Poipreferrednp',preferred_np_id)
      end
    rescue Exception => error
      flash[:notice] = "An unknown error occured: \"#{error}\""
    end
    @pointsofinterest = Pointsofinterest.find_by_id(params[:poi][:id])
    unless @pointsofinterest.blank?
      if @pointsofinterest.preferred_nps.blank?
        @other_preferred_nps = Networkprovider.find(:all, :order => 'name').collect { |np| [np.name,np.id] }   
      else  
        @other_preferred_nps = @pointsofinterest.networkproviders.find(:all, :order => 'name').collect { |np| [np.name,np.id] } 
      end
    end
    render(:partial => "poi_preferred_nps", :layout => false)
  end
  
  def get_list_of_equinix_users
    user_networktermptowner_ids = UserNtpOwner.find(:all, :conditions => "networktermptowner_id = #{Networktermptowner.find_by_name('Equinix').id}").collect{|u| u.user_id}
    equinix_users = User.find(:all, :conditions => "id in (#{user_networktermptowner_ids.join(',')})", :order => 'last_name, first_name').collect { |user| ["#{user.print_name}", user.id] }
    return equinix_users
  end
  
  def get_list_of_poi_connection_types
    (Poiconnectiontype.find(:all).map { |type| ["#{type.name} - #{type.description}", type.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
  
  def add_poi2ntp_prospect
    @change_to_edit = true
    @pointsofinterest = Pointsofinterest.find_by_id(params[:poi][:id])
    set_poi_vars
    @associated_pois = Array.new
    @associated_pois << [@pointsofinterest.name,"#{@pointsofinterest.id}"]
    @associated_pois << [@pointsofinterest.parent_poi.name,"#{@pointsofinterest.parent_poi.id}"] if @pointsofinterest.parent_poi != nil
    @pointsofinterest.children_pois.each do |poi|
      @associated_pois << [poi.name,"#{poi.id}"]
    end
    if params[:new] and params[:new][:id] == "YES" then
      sales_prospect = Poi2ntp.find(:first,:conditions => ["pointsofinterest_id = :poi and networkterminationpoint_id = :ntp",{:poi => params[:poi2ntp][:pointsofinterest_id],:ntp => params[:poi2ntp][:networkterminationpoint_id]}])
      if sales_prospect == nil then
        prospect = create_with_audits('Poi2ntp',params[:poi2ntp])
      else
        flash[:notice] = "That connection already exists!"
      end
      render :partial => 'poi2ntp_prospects_pane', :locals => {:current_poi => @pointofinterest}
    else
      prospect = update_with_audits('Poi2ntp',params[:poi2ntp])
      script_to_run = "<script type=\"text/javascript\">$('poi2ntp_prospect_#{prospect.id}_connection_type').innerHTML = '#{prospect.connectiontype.description.strip}';"
      script_to_run += " $('poi2ntp_prospect_#{prospect.id}_status').innerHTML = '<i>#{prospect.status.status_description.strip if prospect.status != nil}<\/i>';</script>"
      render :text => "<b>#{prospect.networkterminationpoint.name}</b><br/>#{prospect.connectiontype.description.strip}<br/><b>Prospect Status: </b><i>#{prospect.status.status_description.strip if prospect.status != nil}<\/i><br/>"
    end
  end
  
  def add_poi_contact
    @pointsofinterest = Pointsofinterest.find_by_id(params[:pointsofinterest_id])
    phone_number = params[:phone_number]
    email_address = params[:email_address]
    name = params[:name]
    contact = User.find_by_email(email_address)
    if name.blank? and email_address.blank? then
      flash[:notice] = "Name and Email cannot be blank!"
    elsif name.blank? then
      flash[:notice] = "Name cannot be blank!"
    elsif email_address.blank? then
      flash[:notice] = "Email cannot be blank!"
    else
      if contact == nil then
        names = name.split(' ')
        if names.size == 1 then
          first_name = 'Mr./Mrs.'
          last_name = name
        else
          first_name = names[0..(names.size-2)].join(' ')
          last_name = names[(names.size-1)]
        end
        contact = create_with_audits('User',{:first_name => first_name,:last_name => last_name, :email => email_address, :role_id => 5, :active => 'R', :password => 'none', :phone_number => phone_number})      
      else
        if contact.phone_number.blank? then
          contact.phone_number = phone_number
          update_with_audits('User',{:id => contact.id, :phone_number => phone_number})
          contact.save!
        end
      end
      unless contact.associated_with_pointsofinterest?(@pointsofinterest.id)
        create_with_audits('UserPoi',{:pointsofinterest_id => @pointsofinterest.id, :user_id => contact.id})
      end
    end
    render :partial => 'poi_contacts' and return
  end
  
  def add_poi_contact_note
    user_poi = UserPoi.find_by_id(params[:user_poi][:id])
    if params[:new][:id] == "YES"
      @change_to_edit = true
      create_with_audits('UserPoiNote',{:user_poi_id => params[:user_poi][:id], :note => params[:note_text], :user_id => session[:user_id], :date_time => Time.now})
      render :partial => 'poi_contact_notes', :locals => {:user_poi => user_poi} 
    else
      note = update_with_audits('UserPoiNote',{:id => params[:note][:id], :note => params[:note_text]})
      render :text => "#{print_date(note.date_time)} <i>by You</i><div style=\"margin: 0px 0px 0px 40px; display: block;\">#{params[:note_text]}</div>"
    end
  end
  
  def add_poi2ntp_prospect_note
    sales_prospect = Poi2ntp.find_by_id(params[:poi2ntp][:id])
    if params[:new][:id] == "YES"
      @change_to_edit = true
      create_with_audits('Poi2ntpnote',{:poi2ntp_id => params[:poi2ntp][:id], :note => params[:note_text], :date_time => Time.now, :user_id => session[:user_id]})
      render :partial => 'poi2ntp_prospect_notes', :locals => {:sales_prospect => sales_prospect} 
    else
      note = update_with_audits('Poi2ntpnote',{:id => params[:note][:id], :note => params[:note_text]})
      render :text => "#{print_date(note.date_time)} <i>by You</i><div style=\"margin: 0px 0px 0px 40px; display: block;\">#{params[:note_text]}</div>"
    end
  end
  
  def add_poi2ntp_account_note
    @pointsofinterest = Pointsofinterest.find_by_id(params[:poi][:id])
    if params[:new][:id] == "YES"
      @change_to_edit = true
      create_with_audits('Poiaccountnote',{:pointsofinterest_id => params[:poi][:id], :note => params[:note_text], :date_time => Time.now, :user_id => session[:user_id]})
      render :partial => 'poi2ntp_account_notes', :locals => {:poi => @pointsofinterest}
    else
      note = update_with_audits('Poiaccountnote',{:id => params[:note][:id], :note => params[:note_text]})
      render :text => "#{print_date(note.date_time)} <i>by You</i><div style=\"margin: 0px 0px 0px 40px; display: block;\">#{params[:note_text]}</div>"
    end
  end
  
  def edit_poi_service
    flash[:notice] = ''
    @change_to_edit = true
    service_params = params["service_#{params[:service_id]}"]
    if service_params[:name].blank? then
      flash[:notice] += "Service name cannot be blank. Renamed to '(No name)'.<br/>"
      service_params[:name] = '(No name)'
    end
    begin
      if params[:service_id] == 'NEW' then
        @service = create_with_audits('Service',service_params)
      else
        @service = update_with_audits('Service',service_params)
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "A Service with the acronym '#{service_params[:name]}' already exists for this Point of Interest! Use your internet browser's back button to recover changes."
      end
      @pointsofinterest = Pointsofinterest.find_by_id(service_params[:pointsofinterest_id])
      render :partial => 'poi_services' and return
    end
    @pointsofinterest = Pointsofinterest.find_by_id(service_params[:pointsofinterest_id])
    render :partial => 'poi_services', :layout => false
  end
  
  def remove_poi_service
    @change_to_edit = true
    delete_with_audits('Service',params[:deleteId])
    @pointsofinterest = Pointsofinterest.find_by_id(params[:id])
    render :partial => 'poi_services', :layout => false
  end
  
  
  def remove_poi_service_guideline
    delete_with_audits('ServiceGuideline',params[:deleteId])
    service = Service.find_by_id(params[:id])
    @change_to_edit = true
    render :partial => 'poi_service_guidelines', :locals => {:service => service}
  end
  
  def add_poi_service_guideline
    begin
      params[:guideline][:effective_date] = Date.parse(params[:guideline][:effective_date])
      if params[:guideline][:effective_date] == nil then
        flash[:notice] = "Invalid Date Format!"
      else
        create_with_audits('ServiceGuideline',params[:guideline])
      end
    rescue Exception => error
      flash[:notice] = "#{error}"
    end
    service = Service.find_by_id(params[:guideline][:service_id])
    @change_to_edit = true
    render :partial => 'poi_service_guidelines', :locals => {:service => service}
  end
  
  def add_poiaccountexecutive
    current = Poiaccountexecutive.find(:first, :conditions => ["user_id = :user_id and pointsofinterest_id = :poi_id and country_id = :country_id", {:user_id => params[:poiaccountexecutive][:user_id],:poi_id => params[:poiaccountexecutive][:pointsofinterest_id],:country_id => params[:poiaccountexecutive][:country_id]}])
    unless current.nil?
      flash[:notice] = "You are already account manager for that point of interest and country combination."
    else
      create_with_audits('Poiaccountexecutive',params[:poiaccountexecutive]) 
    end
    redirect_to :controller => 'manage', :action => 'account_executive_management'
  end
  
  def add_service
    redirect_to :action => 'edit_service', :id => 'NEW'
  end
  
  def delete_service
    delete_with_audits('Service',params[:id])
    redirect_to :action => 'edit_service', :id => nil
  end
  
  def save_service
    flash[:notice] = ''
    @change_to_edit = true
    service_params = params["service_#{params[:service_id]}"]
    if service_params[:name].blank? then
      flash[:notice] += "Service name cannot be blank. Renamed to '(No name)'.<br/>"
      service_params[:name] = '(No name)'
    end
    begin
      audits = Array.new
      if params[:service_id] == 'NEW' then
        @service = create_with_audits('Service',service_params)
      else
        @service = update_with_audits('Service',service_params)
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "A Service with the acronym '#{service_params[:name]}' already exists for this Point of Interest! Use your internet browser's back button to recover changes."
      end
      redirect_to :action => 'edit_service', :id => nil and return
    end
    redirect_to :action => 'edit_service', :id => @service.id
  end
  
  def edit_service
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_service'
    @page = session[:page]
    
    @selected_region = session[:selected_region]
    @selected_country = session[:selected_country]
    @selected_poi = session[:selected_poi]
    @selected_service = params[:id]
    session[:selected_service] = params[:id]
    
    @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
    @list_of_countries = Country.find(:all, :order => 'name').collect {|c| [c.name,c.id]}
    
    if session[:selected_region] == nil or session[:selected_region] == '-1'
      @list_of_pois = Pointsofinterest.find(:all).map { |poi| [poi.name, "#{poi.id}"]}
    else
      subregions = Equinixregion.find(session[:selected_region]).subregions.collect{|sub| sub.id}
      @list_of_pois = Pointsofinterest.find(:all, :conditions => "id in (#{subregions.join(',')})").collect{|poi| [poi.name,poi.id] } unless subregions.empty?
    end
    
    @list_of_services = Pointsofinterest.find(session[:selected_poi]).services.collect {|s| ["#{s.name}#{" (#{s.service_acronym})" if !s.service_acronym.blank? }", s.id] }
    
    if params[:id] == 'NEW' then
      @service = Service.new()
      @service.pointsofinterest_id = session[:selected_poi]
      @service.service_acronym = "NEW"
      @service.name = "New Service"
      @service.description = "Description"
      session[:selected_service] = nil 
      @modified = true
    else
      @service = Service.find_by_id(params[:id])
    end
  end
  
  private
  
  def variables
    @subnav = "pois"
  end
  
  def set_poi_vars
    @parent_pois = Pointsofinterest.find(:all, :conditions => "id <> #{@pointsofinterest.id}", :order => "name").collect {|poi| [poi.name, poi.id]}
    @poi_types = Poitype.find(:all, :order => "name").collect { |type| [type.name,type.id] }
    region = @pointsofinterest.subregion.equinixregion
    @subregions = region.subregions.find(:all, :order => 'name').collect{|subregion| [subregion.name,subregion.id]}
    @poi_connection_types = Poiconnectiontype.find(:all, :order => 'name').collect { |type| ["#{type.name} - #{type.description}", type.id] }
    @list_of_news = @pointsofinterest.newsitems
    @list_of_countries = Country.find(:all, :order => 'name').collect {|c| [c.name,c.id]}
    user_networktermptowner_ids = UserNtpOwner.find(:all, :conditions => "networktermptowner_id = #{Networktermptowner.find_by_name('Equinix').id}").collect{|u| u.user_id}
    @list_of_equinix_users = User.find(:all, :conditions => "id in (#{user_networktermptowner_ids.join(',')})", :order => 'last_name, first_name').collect { |user| ["#{user.print_name}", user.id] }
    @list_of_equinix_ntps = Networktermptowner.find_by_name("Equinix").networkterminationpoints.find(:all, :order => 'networkterminationpoints.name').collect {|ntp| [ntp.name,ntp.id]}
    @list_of_prospect_status_types = Prospectstatustype.find(:all, :order => 'status_description').collect {|t| [t.status_description,t.id]}
    if @pointsofinterest.aggregations then
      @potential_aggregations = Pointsofinterest.find(:all, :order => 'name').collect {|p| [p.name,p.id]}
    else
      @potential_aggregations = Pointsofinterest.find(:all,:conditions => ["id not in (:current)", {:current => @pointsofinterest.aggregations.collect {|poi| poi.id} }], :order => 'name').collect {|p| [p.name,p.id]}
    end
    
    ntp_connections = @pointsofinterest.networkterminationpoints.collect {|ntp| ntp.id} 
    if ntp_connections.empty? or true then # Always show all ntps. Decision made to show all because multiple connections may exist for the same poi/ntp pair if type is different
      @other_ntp_connections = Networkterminationpoint.find(:all, :order => 'name').collect {|ntp| [ntp.name,ntp.id]}
    else  
      @other_ntp_connections = Networkterminationpoint.find(:all, :conditions => "id not in (#{ntp_connections.join(',')})", :order => 'name').collect {|ntp| [ntp.name,ntp.id]} 
    end
    
    preferred_nps_connections = @pointsofinterest.networkproviders.collect{|np| np.id} 
    if preferred_nps_connections.empty?
      @other_preferred_nps = Networkprovider.find(:all, :order => 'name').collect { |np| [np.name,np.id] }   
    else  
      @other_preferred_nps = Networkprovider.find(:all, :conditions => "id not in (#{preferred_nps_connections.join(',')})", :order => 'name').collect { |np| [np.name,np.id] }    
    end
  end  
  
  def set_new_poi_vars
    @parent_pois = Pointsofinterest.find(:all, :order => "name").collect {|poi| [poi.name, poi.id]}
    @list_of_regions = Equinixregion.find(:all, :order => 'region_name').collect{|r| [r.region_name, r.id]}
    @poi_types = Poitype.find(:all, :order => "name").collect { |type| [type.name, type.id] } 
  end
end
