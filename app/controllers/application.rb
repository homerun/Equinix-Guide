# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON

  helper :all # include all helpers, all the time
  before_filter :authorize, :current_user, :set_app_vars

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '44455cc3a306ee4936c0d8197d175e31'
  
  alias :rescue_action_locally :rescue_action_in_public if EXCEPTIONS_ON

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
  def print_date(dt)
    return dt.strftime('%m/%d/%Y') unless dt.nil?
    return ""
  end
  
  def set_app_vars
    Inflector.inflections do |inflect|
      inflect.irregular 'campus', 'campuses'
    end
  end
  
  def set_modified
    @modified = true
    render :partial => 'shared/modified', :layout => false
  end
  
  private

  def authorize
    # Users can bypass the login for getting to the equinix metro reports if they are
    #  on the equinix sales intranet
    unless request.referer.nil? or request.referer["intranet"].nil?
      return unless request.request_uri["metro_reports"].nil?
    end
    user = User.find_by_id(session[:user_id])
    unless user
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to(:controller => "login", :action => "login") and return
    end
    user.set_last_activity(request.remote_ip,'A')
    redirect_to(:controller => "inquiry", :action => "respond_to_inquiries") if user.is_contact?
  end
  
  def get_audit_trail_obj(table_name,table_id,transaction_id,field_name,action,old_value,new_value)
    audit = Audittrail.new()
    audit.user_id = session[:user_id]
    audit.table_name = table_name
    audit.table_id = table_id
    audit.transaction_id = transaction_id
    audit.field_name = field_name
    audit.action = action
    if old_value != nil and old_value.instance_of? String and old_value.size > 255 then
      audit.old_value = old_value[0..252]+"..."
    else
      audit.old_value = old_value
    end
    if new_value != nil and new_value.instance_of? String and new_value.size > 255 then
      audit.new_value = new_value[0..252]+"..."
    else
      audit.new_value = new_value
    end
    return audit
  end
  
  def get_create_audit_objects(table_name,currentObject)
    audits = Array.new
    eval(table_name).columns.each {|column| audits << get_audit_trail_obj(table_name,currentObject.id,1,column.name,'C',nil,eval("currentObject.#{column.name}")) unless column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at'}
    audits
  end
  
  def get_delete_audit_objects(table_name,currentObject,transaction_id)
    audits = Array.new
    eval(table_name).columns.each {|column| audits << get_audit_trail_obj(table_name,currentObject.id,transaction_id,column.name,'D',eval("currentObject.#{column.name}"),nil) unless column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at'}
    audits
  end
  
  def get_update_audit_objects(table_name,currentObject,fieldValues,transaction_id)
  #def get_update_audit_objects(table_name,currentObject,fieldValues)
    audits = Array.new
    eval(table_name).columns.each {|column| audits << get_audit_trail_obj(table_name,currentObject.id,transaction_id,column.name,'U',eval("currentObject.#{column.name}"),fieldValues[column.name]) unless column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at' or fieldValues[column.name] == nil or "#{eval("currentObject.#{column.name}")}".chomp == "#{fieldValues[column.name]}".chomp}
    #eval(table_name).columns.each {|column| audits << get_audit_trail_obj(table_name,currentObject.id,column.name,'U',eval("currentObject.#{column.name}"),fieldValues[column.name]) if column.name != 'id' and "#{eval("currentObject.#{column.name}")}" != "#{fieldValues[column.name]}"}
    return audits
  end
  
  def create_with_audits(table_name,fieldValues)
    obj = eval(table_name).new(fieldValues)
    obj.save!
    get_create_audit_objects(table_name,obj).each {|audit| audit.save}
    obj
  end
  
  def delete_with_audits(table_name,id)
    obj = eval(table_name).find_by_id(id)
    transactionMax = Audittrail.maximum(:transaction_id,:conditions => ["table_name = '#{table_name}' and table_id = #{id}"])
    transactionMax = 0 if transactionMax == nil
    audits = get_delete_audit_objects(table_name,obj,transactionMax+1)
    obj.destroy
    audits.each {|audit| audit.save}
  end
  
  def update_with_audits(table_name,fieldValues)
    obj = eval(table_name).find_by_id(fieldValues[:id])
    transactionMax = Audittrail.maximum(:transaction_id,:conditions => ["table_name = '#{table_name}' and table_id = #{fieldValues[:id]}"])
    transactionMax = 0 if transactionMax == nil
    audits = get_update_audit_objects(table_name,obj,fieldValues,transactionMax+1)
    #audits = get_update_audit_objects(table_name,obj,fieldValues)
    obj = eval(table_name).update(obj.id,fieldValues)
    obj.save
    audits.each {|audit| audit.save}
    obj
  end
  
  def get_changes(obj,new_values)
    changes = []
    return changes if new_values.nil?
    obj.class.columns.each do |column|
      unless column.name == 'id' or column.name == 'created_at' or column.name == 'updated_at' or new_values[column.name] == nil or "#{obj.send(column.name)}".chomp == "#{new_values[column.name]}".chomp
        changes << {:field_name => column.name, :old_value => obj.send(column.name), :new_value => new_values[column.name]}        
      end
    end
    return changes
  end
  
  def hash_email(email)
    string_to_hash = email + "_change_me"
    string_to_hash.unpack('U'*string_to_hash.length).join
  end
  
  
  def obj_list_contains_id(list, id)
    return false if list == nil
    list.each {|obj| return true if "#{obj.id}" == "#{id}" }
    return false
  end
  
  def opt_list_contains_id(list, id)
    return false if list == nil
    list.each {|obj| return true if obj[1] == "#{id}" }
    return false
  end
  
  def escapeKML(str)
    str.gsub(/&/,'&amp;')
  end
  
  def print_name_with_association(user)
    association = ''
    if !user.networkproviders.nil?
      np = user.networkproviders.collect{|np| np.name}
      association = " (#{np.join(',')})" unless np.nil?
    elsif !user.networktermptowners.nil?
      ntp = user.networktermptowners.collect{|ntp| ntp.name}
      association = " (#{ntp.join(',')})" unless ntp.nil?
    elsif !user.pointsofinterests.nil?
      poi = user.pointsofinterests.collect{|p| p.name}
      association = " (#{poi.join(',')})" unless poi.nil?
    end
    return "#{user.print_name}#{association}"
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
      unitClass = @current_user.unit_preference
    end
    if unitClass == 'M' then
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
  
  
  def add_user_to_list(list,user_id)
    return if list == nil or list.contains_user(user_id)
    userListItem = create_with_audits('Userlistitem',{:listId => list.id, :user_id => user_id})
    userListItem.save!
  end
  
  def remove_user_from_list(list,user_id)
    return if list == nil or !list.contains_user(user_id)
    list.useritems.each do |userItem|
      delete_with_audits('Userlistitem',userItem.id) if userItem.user_id == user_id
    end
  end
  
  def remove_contest_from_list(list,user_id)
    return if list == nil or !list.contains_user(user_id)
    list.contest_items.each do |contestItem|
      delete_with_audits('Contestlistitem',contestItem.id) if contestItem.user_id == user_id
    end
  end
  
  def get_audits_for_object(object_table,object_tableId,beginDateTime=nil,endDateTime=nil,updatesOnly = false,specific_fields=[])
    if specific_fields.empty? then
      field_selection_criteria = ""
    else
      field_selection_criteria = "and field_name in ('#{specific_fields.join("','")}')"
    end
    child_audits = Array.new
    beginDateTime = Time.parse("1/1/2008") if beginDateTime == nil
    beginDateTime = Time.parse(beginDateTime.strftime("%Y-%m-%d")) #if beginDateTime.is_a?(Date)
    endDateTime = Time.now if endDateTime == nil
    if updatesOnly then
      auditTypes = " and action = 'U'"
    else
      auditTypes = ""
    end
    if object_tableId == 'All'
      audits = Audittrail.find(:all,:conditions => ["table_name = :table#{auditTypes} and created_at >= :begin_date and created_at <= :end_date #{field_selection_criteria}", {:table => object_table, :begin_date => beginDateTime, :end_date => endDateTime}])
      child_audits  += get_audits_for_object('Np2ntp','All',beginDateTime,endDateTime) if object_table == 'Networkterminationpoint' or object_table == 'Networkprovider'
      child_audits  += get_audits_for_object('Poi2ntp','All',beginDateTime,endDateTime) if object_table == 'Networkterminationpoint' or object_table == 'Pointsofinterest'
      child_audits  += get_audits_for_object('Poipreferrednp','All',beginDateTime,endDateTime) if object_table == 'Networkterminationpoint' or Networkprovider == 'Pointsofinterest'
      child_audits  += get_audits_for_object('Datacenter','All',beginDateTime,endDateTime) if object_table == 'Networkterminationpoint' and @current_user.is_equinix_user?
      child_audits  += get_audits_for_object('Networkterminationpoint','All',beginDateTime,endDateTime) if object_table == 'Networktermptowner'
    elsif object_tableId == 'New'
      audits = Audittrail.find(:all,:conditions => ["table_name = :table and action = 'C' and created_at >= :begin_date and created_at <= :end_date #{field_selection_criteria}", {:table => object_table, :begin_date => beginDateTime, :end_date => endDateTime}])
    else
      audits = Audittrail.find(:all,:conditions => ["table_name = :table and table_id = :id#{auditTypes} and created_at >= :begin_date and created_at <= :end_date #{field_selection_criteria}", {:table => object_table, :id => object_tableId, :begin_date => beginDateTime, :end_date => endDateTime}])
      obj = eval("#{object_table}.find_by_id(#{object_tableId})")
      
      # Network Termination Point Children objects
      if object_table == 'Networkterminationpoint' and @current_user.can_view_page?('edit_ntp',obj.id) and specific_fields.empty? then
        child_audits += get_audits_for_object('Datacenterdetail',obj.datacenterdetail.id) if obj.datacenterdetail != nil and @current_user.is_equinix_user? 
        obj.np_connections.each do |np_connection|
          child_audits += get_audits_for_object('Np2ntp',np_connection.id,beginDateTime,endDateTime)
        end if obj.np_connections != nil
        obj.poi_connections.each do |poi_connection|
          child_audits += get_audits_for_object('Poi2ntp',poi_connection.id,beginDateTime,endDateTime) 
        end if obj.poi_connections != nil
        
      # Network Provider Children Objects
      elsif object_table == 'Networkprovider' and @current_user.can_view_page?('edit_networkprovider',obj.id) then
        obj.ntp_connections.each do |ntp_connection|
          child_audits += get_audits_for_object('Np2ntp',ntp_connection.id,beginDateTime,endDateTime)
        end if obj.ntp_connections != nil
        obj.preferred_pois.each do |preferred_poi|
          child_audits += get_audits_for_object('Poipreferrednp',preferred_poi.id,beginDateTime,endDateTime)
        end if obj.preferred_pois != nil
      
      # Points of Interest Children Objects
      elsif object_table == 'Pointsofinterest' and @current_user.can_view_page?('edit_poi',obj.id)
        obj.all_ntp_connections.each do |ntp_connection|
          child_audits += get_audits_for_object('Poi2ntp',ntp_connection.id,beginDateTime,endDateTime) if ntp_connection.public
        end if obj.ntp_connections != nil
        obj.preferred_nps.each do |preferred_np|
          child_audits += get_audits_for_object('Poipreferrednp',preferred_np.id,beginDateTime,endDateTime) 
        end if obj.preferred_nps != nil
        obj.account_notes.each do |account_note|
          child_audits += get_audits_for_object('Poiaccountnote',account_note.id,beginDateTime,endDateTime) 
        end if @current_user.is_equinix_user? and obj.account_notes != nil
        obj.account_executives.each do |account_executive|
          child_audits += get_audits_for_object('Poiaccountexecutive',account_executive.id,beginDateTime,endDateTime) 
        end if @current_user.is_equinix_user? and obj.account_executives != nil
        obj.services.each do |service|
          child_audits += get_audits_for_object('Service',service.id,beginDateTime,endDateTime) 
        end if obj.services != nil
        obj.pointsofinterest_provider_categories.each do |category|
          child_audits += get_audits_for_object('PointsofinterestProviderCategory',category.id,beginDateTime,endDateTime) 
        end if obj.pointsofinterest_provider_categories != nil
        obj.aggregated_pointsofinterests.each do |aggregation|
          child_audits += get_audits_for_object('PointsofinterestAggregation',aggregation.id,beginDateTime,endDateTime) 
        end if obj.aggregated_pointsofinterests != nil
        
      #Network Termination Point Owner Children Objects
      elsif object_table == 'Networktermptowner' and @current_user.can_view_page?('edit_ntp_owner',obj.id)
        obj.networkterminationpoints.each do |ntp|
          child_audits += get_audits_for_object('Networkterminationpoint',ntp.id,beginDateTime,updatesOnly) 
        end if obj.networkterminationpoints != nil
        
      #Service Children Objects
      elsif object_table == 'Service' and @current_user.can_view_page?('edit_poi',obj.id)
        obj.guidelines.each do |guideline|
          child_audits += get_audits_for_object('ServiceGuideline',guideline.id,beginDateTime,updatesOnly) 
        end if obj.guidelines != nil
        
      #Campus Children Objects
      elsif object_table == 'Campus' and @current_user.can_view_page?('edit_campus',obj.id)
        obj.networkterminationpoints.each do |ntp|
          child_audits += get_audits_for_object('Networkterminationpoint',ntp.id,beginDateTime,endDateTime,updatesOnly,['campus_id','campus_access_type_id']) 
        end unless obj.networkterminationpoints.nil?
      end
    end
    object_hash = Hash.new
    audits.each do |audit|
      object = eval("#{object_table}.find_by_id(#{audit.table_id})")
      if object != nil
        object_hash[object] = Hash.new if object_hash[object] == nil
        object_hash[object][audit.transaction_id] = Array.new if object_hash[object][audit.transaction_id] == nil
        object_hash[object][audit.transaction_id] << audit
      end
    end
    object_list = Array.new
    object_hash.each_pair do |obj,seq_audit_hash|
      grouped_audits_list = Array.new
      seq_audit_hash.each_pair do |sequence,time_audits|
        grouped_audits_list << get_audit_summary_for_time(obj,object_table,time_audits) unless table_label(object_table).nil?
      end
      grouped_audits_list.sort! {|x,y| y[:date_time] <=> x[:date_time]}
      object_list << [obj,grouped_audits_list]
    end
    object_list += child_audits
    #flash[:notice] = object_list
    #TODO: the following line was erroring because of modifications to this function...
    #object_list.sort! {|x,y| x[1][0][:title] <=> y[1][0][:title]}    
    #begin
      object_list.sort! {|x,y| ((x[1] and x[1].size > 0)?((x[1][0][:date_time].blank?)?(DateTime.now):(x[1][0][:date_time])):(DateTime.now)) <=> ((y[1] and y[1].size > 0)?((y[1][0][:date_time].blank?)?(DateTime.now):(y[1][0][:date_time])):(DateTime.now))}
    #rescue
      
    #end
    return object_list 
  end
  
  def get_audit_summary_for_time(object,object_table,audits)
    if @current_user.unit_preference == 'M'
      blacklist = 'british'
    else
      blacklist = 'metric'
    end
    responsible_user = nil
    table = table_label(object_table)
    title = table.title(object.id)
    date_time = audits[0].created_at
    changed_fields = Array.new
    audits.each do |audit|
      responsible_user = audit.user if responsible_user == nil
      field = field_label(audit)
      if field != nil and !field.field_name.include?(blacklist) then
        field_name = field.label
        if field.translate_value? then
          if field.translate_value(audit.old_value).blank? or field.translate_value(audit.old_value) == nil then
            old_value = '(none)'
          else
            old_value = field.translate_value(audit.old_value)
          end
        else
          if audit.old_value.blank? or audit.old_value == nil then
            old_value = '(none)'
          else
            old_value = audit.old_value
          end
        end
        if field.translate_value? then
          if field.translate_value(audit.new_value) == nil or field.translate_value(audit.new_value).blank? then
            new_value = '(none)'
          else
            new_value = field.translate_value(audit.new_value)
          end
        else
          if audit.new_value == nil or audit.new_value.blank? then
            new_value = '(none)'
          else 
            new_value = audit.new_value
          end
        end
        title = old_value if table.look_up_field == field.field_name and audit.action != 'C' and old_value != '(none)'
        changed_fields << {:field_name => field_name, :old_value => old_value, :new_value => new_value, :id => audit.id} if new_value != old_value
      #else
      #  changed_fields << {:field_name => audit.field_name, :old_value => audit.old_value, :new_value => audit.new_value}
      end
    end
    description = "#{ title } #{ action_descr(audits[0]) }."
    return {:title => title, :responsible_user => responsible_user, :date_time => date_time, :description => description, :changed_fields => changed_fields, :object => object }
  end
  
  def field_label(auditOrTable,field = nil)
    if field == nil then
      table = auditOrTable.table_name
      field = auditOrTable.field_name
    else
      table = auditOrTable
    end
    label = Tablefieldlabel.find(:first,:conditions => ["table_name = :table and field_name = :field", {:table => table, :field => field}])
    return label
  end
  
  def table_label(table)
    label = Tablelabel.find(:first,:conditions => ["table_name = '#{table}'"])
    return label
  end
  
  def action_descr(audit)
    return "added to database" if audit.action == 'C'
    return "deleted from database" if audit.action == 'D'
    return "updated in database" if audit.action == 'U'
    return "changed"
  end
  
  def combine_grouped_audits(obj,grouped_audits)
    return nil if grouped_audits == nil
    audits = Array.new
    grouped_audits.each {|x| audits += x[1]}
    audits.sort! {|x,y| y[:date_time] <=> x[:date_time]}
    return [obj,audits]
  end
  
  def is_extranet_provider(user = nil)
    user = User.find_by_id(session[:user_id]) if user == nil
    return false if user.networkproviders.nil?
    user.networkproviders.each do |np|
      return true if np.extranet_type == true
    end
    return false
  end
  
  def get_miles_distance(ntpSelf, ntpOther)
    if ntpOther.kind_of?(Hash) then
      other_lat = ntpOther[:lat]
      other_lon = ntpOther[:lon]
      self_lat = ntpSelf.lat.to_f
      self_lon = ntpSelf.lon.to_f
    else
      if ntpOther.lat == nil or ntpOther.lon == nil or ntpSelf.lat == nil or ntpSelf.lon == nil then
        return 999999
      end
      other_lat = ntpOther.lat.to_f
      other_lon = ntpOther.lon.to_f
      self_lat = ntpSelf.lat.to_f
      self_lon = ntpSelf.lon.to_f
    end
    to_rads = Math::PI / 180.0
    begin
      d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    rescue
      return 0
    end
    d
  end
  
  
  def get_center_of_market_map(market)
    return nil if market.nil?
    location_count = 0
    lat_tot = 0.0
    lon_tot = 0.0
    market.datacenters.each do |datacenter|
      if !datacenter.networkterminationpoint.lat.blank? and !datacenter.networkterminationpoint.lon.blank? and (datacenter.networkterminationpoint.lat != 0 or datacenter.networkterminationpoint.lon != 0) then
        location_count += 1
        lat_tot += datacenter.networkterminationpoint.lat.to_f
        lon_tot += datacenter.networkterminationpoint.lon.to_f
      end
    end if market.datacenters != nil
    return {:lat => (lat_tot/location_count), :lon => (lon_tot/location_count)}
  end
  
  def get_yui_hash(model_obj, table_name, columns, order_by, where="")
     # Pagination & Search Logic
     if( (params[:startIndex].nil? or params[:startIndex].empty?) and
         (params[:results].nil? or params[:results].empty?) )
       limit = ""
     elsif( (params[:startIndex].nil? or params[:startIndex].empty?) and
          (!params[:results].nil? and !params[:results].empty?) )
       limit = "LIMIT #{params[:results]}"
     elsif( (!params[:startIndex].nil? and !params[:startIndex].empty?) and
          (params[:results].nil? or params[:results].empty?) )
       limit = "LIMIT #{params[:startIndex]},99999999999"
     else  
       limit = "LIMIT #{params[:startIndex]},#{params[:results]}"
     end

     column_select_array = []
     column_where_join_array = []
     column_where_search_array = []
     table_name_alias = table_name[0..1] + "01"
     table_select_array = ["#{table_name} #{table_name_alias}"] # we know that we'll be selecting from the local table at the least
     order_by = order_by.gsub("#{table_name}", "#{table_name_alias}")
     where = where.gsub("#{table_name}", "#{table_name_alias}")
     
     columns.each_with_index do |col,index|
       # col[:name] will always be unique so if there need to be two fields that have
       # the same key then the key should be specified using the col[:col] variable
       col[:col] = col[:name] if col[:col].nil? or col[:col].empty?
       
       # We don't do anything if the column is a link
       if col[:link_type].nil? or col[:link_type].empty?
         
         # We need to lookup remote fields when there are simple 1 to 1 relationships
         if col[:type] == "lookup"
           remote_table_name = col[:model].table_name
           remote_table_name_alias = remote_table_name[0..1] + index.to_s
           order_by = order_by.gsub("#{remote_table_name}", "#{remote_table_name_alias}")
           where = where.gsub("#{remote_table_name}", "#{remote_table_name_alias}")

           # Any remote tables are Outer joined join tables
           table_select_array << "LEFT OUTER JOIN #{remote_table_name} #{remote_table_name_alias} ON #{table_name_alias}.#{col[:col]} = #{remote_table_name_alias}.id "

           # Set up the joins and the select fields
           #column_where_join_array << "#{table_name}.#{col[:col]} = #{remote_table_name}.id"
           column_select_array << "#{table_name_alias}.#{col[:col]} as #{col[:col]}"
           
           # pull the tags out of the format and add the columns to the select statement
           col[:tags] = []
           col[:format].scan(/\[\[(.*?)\]\]/).each do |df|
             col[:tags] << df # Let's pull these into an array so we don't have to do a regex again
             column_select_array << "#{remote_table_name_alias}.#{df} as #{remote_table_name}_#{col[:col]}_#{df}"
             
             unless(params[:search].nil? or params[:search].empty?)
               column_where_search_array << "#{remote_table_name_alias}.#{df} LIKE '%#{params[:search]}%'"
             end
           end
         else
           column_select_array << "#{table_name_alias}.#{col[:col]} as #{col[:col]}"
           
           unless(params[:search].nil? or params[:search].empty?)
             column_where_search_array << "#{table_name_alias}.#{col[:col]} LIKE '%#{params[:search]}%'"
           end
         end
       end
     end
     #logger.info("Table Array: #{table_select_array.inspect}")
     
     custom_count_sql = "SELECT COUNT(*)" +
                        "FROM #{table_select_array.uniq.join(" ")} " +
                        "#{(column_where_search_array.length > 0 or (!where.nil? and !where.empty?))? "WHERE ": ""}" +
                        "#{(column_where_search_array.length > 0)? "( #{column_where_search_array.uniq.join(" OR ")} ) ": ""}" +
                        "#{(column_where_search_array.length > 0 and (!where.nil? and !where.empty?))? "AND ": ""}" +
                        "#{(!where.nil? and !where.empty?)? "( #{where} ) ": ""}"
     custom_sql = "SELECT #{column_select_array.uniq.join(",")} " +
                  "FROM #{table_select_array.uniq.join(" ")} " +
                  "#{(column_where_search_array.length > 0 or (!where.nil? and !where.empty?))? "WHERE ": ""}" +
                  "#{(column_where_search_array.length > 0)? "( #{column_where_search_array.uniq.join(" OR ")} ) ": ""}" +
                  "#{(column_where_search_array.length > 0 and (!where.nil? and !where.empty?))? "AND ": ""}" +
                  "#{(!where.nil? and !where.empty?)? "( #{where} ) ": ""}" +
                  "#{(order_by=='')? "": "ORDER BY " + order_by} " +
                  "#{limit}"
                  
     logger.info("CUSTOM SQL: #{custom_sql}")             
     logger.info("CUSTOM COUNT SQL: #{custom_count_sql}")
     results = model_obj.find_by_sql( custom_sql )
     
     # Setup total_records, records_returned and start_index
     total_records = model_obj.count_by_sql( custom_count_sql )
     records_returned = results.length
     start_index = 0
     unless(params[:startIndex].nil? or params[:startIndex].empty?)
       start_index = params[:startIndex]
     end
     
     # Setup item results in hash
     contact_array = []
     #logger.info("RESULTS: #{results.inspect}")
     results.each do |row|
       row_hash = {}
       columns.each_with_index do |col,index|
       	 # Remove special escape chars
       	 col[:col] = col[:col].delete("`")
       	 col[:name] = col[:name].delete("`")
         if !col[:link_type].nil? and !col[:link_type].empty?
           row_hash[col[:name]] = col[:label]
           next
         end
         
         if row[col[:col]].nil?
           row_hash[col[:name]] = ""
           next
         end
         
         if col[:type] == "date"
           row_hash[col[:name]] = row[col[:col]].strftime("%Y-%m-%d %H:%M:%S")
         elsif col[:type] == "text"
           row_hash[col[:name]] = "#{(row[col[:col]].length >= 100)? "#{row[col[:col]][0..100]}...": row[col[:col]]}"
         elsif col[:type] == "lookup"
           col[:key] = "id" if col[:key].nil? or col[:key].empty?
           unless row[col[:col]].nil?
             lookup_string = col[:format]
             col[:tags].each do |df|
               rep_val = ""
               rep_val = row["#{col[:model].table_name}_#{col[:col]}_#{df[0]}"] unless row["#{col[:model].table_name}_#{col[:col]}_#{df[0]}"].nil?
               lookup_string = lookup_string.gsub( "[[#{df[0]}]]", rep_val )
             end
             #logger.info("LOOKUP STRING: #{lookup_string}")
             row_hash[col[:name]] = lookup_string
           else
             row_hash[col[:name]] = ""
           end
         else
           row_hash[col[:name]] = row[col[:col]]
         end
       end
        contact_array << row_hash
     end
     
     # Setup Options
     contact_options = { 
       :recordsReturned => records_returned, 
       :totalRecords => total_records,
       :startIndex => start_index,
       :sort => "null", 
       :dir => "asc",
       :items => contact_array
     }
     
     # Name the Overall Hash
     contact_hash = { table_name => contact_options }
     contact_hash
   end
   
  def get_csv_export(model_obj, table_name, columns, order_by, where="")
    csv = ""
    csv_headers = []
    
    # Create Headers
    columns.each do |col|
      csv_headers << col[:label] unless col[:hidden] or col[:link_type]
    end
    
    csv = "\"#{csv_headers.join("\",\"")}\"\n"
    csv_hash = get_yui_hash(model_obj, table_name, columns, order_by, where)

    csv_hash[table_name][:items].each do |csv_record|
      csv_record_array = []
      columns.each do |col|
        unless col[:hidden] or csv_record[col[:name]].nil? or col[:link_type]
          cell = csv_record[col[:name]]
          if cell == true 
            cell = "true"
          elsif cell == false
            cell = "false"
          end 
          csv_record_array << cell.gsub(/\"/, "\"\"")  
        end
      end
      csv += "\"#{csv_record_array.join("\",\"")}\"\n"
    end
    csv
  end
  
  def get_yui_json(model_obj, table_name, columns, order_by, where="")
    get_yui_hash(model_obj, table_name, columns, order_by, where).to_json
  end
  
  def get_csv_content_type
    content_type = if request.user_agent =~ /windows/i
      'application/vnd.ms-excel'
    else
      'text/csv'
    end
  end
  
  def set_yui_vars(controller=nil)
    @initial_rows_per_page = 10
    @table_name = @model.table_name
    @json_url = "/#{(controller.nil?)?(@table_name):controller}/json?"
    
    @json_url += "search=#{params[:search]}&" if params[:search] and (params[:commit] == "Search" or params[:commit].blank?)
    params[:search] = nil if params[:commit] == "Reset"
    @export_csv = true
    
    @edit_url = url_for(:action => "edit")
    @destroy_url = url_for(:action => "destroy")
    @share_report_url = url_for(:action => "share_report")
    @open_report_url = url_for(:action => "open_report")
    @login_as_url = url_for(:action => "login_as") if @current_user.is_super?
  end
  
end
