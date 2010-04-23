class ReportsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def index
    @subnav = "saved_reports"
    session[:original_uri] = request.request_uri
    session[:page] = 'reports_index'
    set_view_saved_reports_variables
  	set_json_vars
  end

  def json
    set_json_vars
    render :text => get_yui_hash(@model, @table_name, @columns, @order_by, @where).to_json
  end
  
  def new
    @report = Report.new
    @reporttype = Reporttype.find_by_page_name("#{params[:reporttype]}")
    set_new_vars
  end
    
  def create
    @report = Report.new(params[:report])
    @reporttype = Reporttype.find(params[:report][:reporttype_id])
    set_new_vars
    if @report.save
      Audittrail.new.create_new_audit(@current_user, "Report", @report.id)
      @list_of_parameters.each do |parameter|
        create_with_audits('Reportparameter',{:report_id => @report.id, :key => parameter[:key], :value => parameter[:value]})
      end
      flash[:notice] = 'Report Saved Successfully!'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end  
  end
  
  def open_report
    if params[:sharable] == 'yes' then
      real_id = (params[:id].to_i + 321)/9999
    else
      real_id = params[:id].to_i
    end
    report = Report.find_by_id(real_id)
    report.reportparameters.each do |parameter|
      if not parameters.value.nil? and parameter.value[0..0] == '[' then
        session[eval(":#{parameter.key}")] = eval(parameter.value)
      else
        session[eval(":#{parameter.key}")] = parameter.value
      end
    end
    user = User.find_by_id(session[:user_id])
    if has_shared_report?(user.sharedreports,report.id) then
      owner = 'shared'
    else
      owner = 'me'
    end
    redirect_to :controller => report.reporttype.controller_name, :action => report.reporttype.page_name, :owner => owner, :filename => report.report_title, :report_id => real_id
  end
  
  def unshare_report
    if session[:page] == 'index' then
      if params[:unshareId] == 'ALL' then
        Report.find_by_id(params[:report_id]).shared_users.each do |shared_user|
          delete_with_audits('Sharedreport',shared_user.id)
        end
      else
        delete_with_audits('Sharedreport',params[:unshareId])
      end
      set_view_saved_reports_variables
      render :partial => params[:update]
    else # if session[:page] == 'edit' then
      delete_with_audits('Sharedreport',params[:unshareId])
      @report = Report.find_by_id(params[:id])
      set_edit_report_variables(@report)
      render :partial => 'edit_report_shared_users_pane'
    end
  end
  
  def do_share_report
    user = User.find_by_id(params[:user_id])
    @report = Report.find_by_id(params[:id])
    unless user.nil?
      create_with_audits('Sharedreport',{:report_id => params[:id], :user_id => params[:user_id]})
      UserMailer.deliver_shared_report(@report,@current_user,user)
    end
    set_edit_report_variables(@report)
    render :partial => 'edit_report_shared_users_pane'
  end
  
  def edit
    session[:original_uri] = request.request_uri
    session[:page] = 'edit'
    if request.post? then
      if params[:report].nil? or params[:report][:id].nil?
        @report = create_with_audits('Report',params[:report])
        flash[:notice] = 'Report Created Successfully!'
      else
        @report = update_with_audits('Report',params[:report])
        flash[:notice] = 'Report Saved Successfully!'
      end
    else
      @report = Report.find_by_id(params[:id])
    end
    set_edit_report_variables(@report)
  end  
  
  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(params[:report])
      flash[:notice] = "Report successfully updated"
      redirect_to :action => "index"
    else
      set_edit_report_variables(@report)
      render :action => "edit"
    end
  end
  
  def select_ntp_owners
    session[:selected_networktermptowner_ids] = params[:ntp_owner_ids]
    @selected_ntp_owners = session[:selected_networktermptowner_ids]
    @report = Report.find_by_id(params[:id]) 
    @list_of_ntp_owners = get_list_of_ntp_owners(@report.shared_users)
    @selected_ntp_owners.delete_if {|x| !opt_list_contains_id(@list_of_ntp_owners,x) } if @selected_ntp_owners != nil
    @list_of_users_with_ntp_owners = Array.new
    UserNtpOwner.find(:all,:conditions => ["networktermptowner_id in (:id_list)", {:id_list => @selected_ntp_owners}]).each do |user_ntp_owner|
      @list_of_users_with_ntp_owners << user_ntp_owner.user if !user_ntp_owner.user.nil? and !has_shared_report?(user_ntp_owner.user.sharedreports,params[:id]) and user_ntp_owner.user_id != session[:user_id]
    end if @selected_ntp_owners != nil
    render :partial => 'list_of_users_with_ntp_owners'
  end  
  
  def select_pois
    session[:selected_pois] = params[:pointsofinterest_ids]
    @selected_pois = session[:selected_pois]
    @report = Report.find_by_id(params[:id])
    @list_of_pois = get_list_of_pois(@report.shared_users)
    @selected_pois.delete_if {|x| !opt_list_contains_id(@list_of_pois,x) } if @selected_pois != nil
    @list_of_users_with_pois = Array.new
    UserPoi.find(:all,:conditions => ["pointsofinterest_id in (:id_list)", {:id_list => @selected_pois}]).each do |user_poi|
      @list_of_users_with_pois << user_poi.user if !user_poi.user.nil? and !has_shared_report?(user_poi.user.sharedreports,params[:id]) and user_poi.user_id != session[:user_id]
    end if @selected_pois != nil
    render :partial => 'list_of_users_with_pois'
  end  
  
  def select_nps
    session[:selected_nps] = params[:np_ids]
    @selected_nps = session[:selected_nps]
    @report = Report.find_by_id(params[:id])
    @list_of_nps = get_list_of_nps(@report.shared_users)
    @selected_nps.delete_if {|x| !opt_list_contains_id(@list_of_nps,x) } if @selected_nps != nil
    @list_of_users_with_nps = Array.new
    UserNp.find(:all,:conditions => ["networkprovider_id in (:id_list)", {:id_list => @selected_nps}]).each do |user_np|
      @list_of_users_with_nps << user_np.user if !user_np.user.nil? and !has_shared_report?(user_np.user.sharedreports,params[:id]) and user_np.user_id != session[:user_id]
    end if @selected_nps != nil
    render :partial => 'list_of_users_with_nps'
  end
  
  def select_customer_groups
    session[:selected_customer_groups] = params[:user_ids]
    @selected_customer_groups = session[:selected_customer_groups]
    @report = Report.find_by_id(params[:id])
    @list_of_customer_groups = get_list_of_customer_groups(@report.shared_users)
    @selected_customer_groups.delete_if {|x| !opt_list_contains_id(@list_of_customer_groups,x) } if @selected_customer_groups != nil
    @list_of_users_with_customer_groups = Array.new
    UserCustomerGroup.find(:all,:conditions => ["customer_group_id in (:id_list)", {:id_list => @selected_customer_groups}]).each do |user_customer_group|
      @list_of_users_with_customer_groups << user_customer_group.user if user_customer_group.user.nil? and !has_shared_report?(user_customer_group.user.sharedreports,params[:id]) and user_customer_group.user_id != @current_user.id
    end if @selected_customer_groups != nil
    render :partial => 'list_of_users_with_customer_groups'
  end
  
  
  def destroy
    Report.find(params[:id]).destroy
    redirect_to :action => "index"
  end
  
  def export
    set_json_vars
    send_data( get_csv_export(@model, @table_name, @columns, @order_by, @where), 
               :type => get_csv_content_type,
               :filename => "saved_reports.csv")
  end
  
  def share_report
    @report = Report.find_by_id(params[:id])
    
    @list_of_ntp_owners = (UserNtpOwner.find(:all).collect {|association| association.networktermptowner}).uniq.collect{|ntp_owner| [ntp_owner.name,ntp_owner.id]}
    (@list_of_ntp_owners.sort! {|x,y| x[0].downcase <=> y[0].downcase}).insert(0,['All','All']) if @list_of_ntp_owners.size > 1
    @list_of_ntp_owners.insert(0,[' ','None'])
    @list_of_networkproviders = (UserNp.find(:all).collect {|association| association.networkprovider}).uniq.collect{|np| [np.name,np.id]}
    (@list_of_networkproviders.sort! {|x,y| x[0].downcase <=> y[0].downcase}).insert(0,['All','All']) if @list_of_networkproviders.size > 1
    @list_of_networkproviders.insert(0,[' ','None'])
    @list_of_pointsofinterests = (UserPoi.find(:all).collect {|association| association.pointsofinterest}).uniq.collect{|poi| [poi.name,poi.id]}
    (@list_of_pointsofinterests.sort! {|x,y| x[0].downcase <=> y[0].downcase}).insert(0,['All','All']) if @list_of_pointsofinterests.size > 1
    @list_of_pointsofinterests.insert(0,[' ','None'])
    @list_of_customer_groups = (UserCustomerGroup.find(:all).collect {|association| association.customer_group}).uniq.collect{|grp| [grp.name,grp.id]}
    (@list_of_customer_groups.sort! {|x,y| x[0].downcase <=> y[0].downcase}).insert(0,['All','All']) if @list_of_customer_groups.size > 1
    @list_of_customer_groups.insert(0,[' ','None'])
    
    @list_of_add_users = list_of_users_from_search
    unless @list_of_add_users.nil?
      @list_of_add_users = @list_of_add_users.collect {|user| [user.print_name_with_association,user.id]}
      @list_of_add_users.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @add_users_list_size = [[@list_of_add_users.size,15].min,5].max
    end
    
    unless @report.sharedreports.nil?
      @list_of_remove_users = @report.sharedreports.collect {|sharedreport| [(sharedreport.shared_user.nil?)?("User not found: #{sharedreport.id}-#{sharedreport.user_id}"):(sharedreport.shared_user.print_name_with_association),sharedreport.id]}
      @list_of_remove_users.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @remove_users_list_size = [[@list_of_remove_users.size,15].min,5].max
    else
      @list_of_remove_users = Array.new
    end
  end
  
  def update_add_users_list
    @report = Report.find_by_id(params[:id])
    
    @list_of_add_users = list_of_users_from_search
    unless @list_of_add_users.nil?
      @list_of_add_users = @list_of_add_users.collect {|user| [user.print_name_with_association,user.id]}
      @list_of_add_users.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @add_users_list_size = [[@list_of_add_users.size,15].min,5].max
    end
    render :partial => 'add_users_selector'
  end
  
  def add_selected_users
    @report = Report.find_by_id(params[:id])
    
    current_users = @report.shared_users.collect {|user| "#{user.id}"}
    params[:add_users_list].each do |user_id|
      user = User.find_by_id(user_id)
      unless user.nil? or current_users.include?(user_id)
        create_with_audits('Sharedreport',{:report_id => @report.id, :user_id => user_id})
        if params[:send_email] then
          UserMailer.deliver_shared_report(@report,@current_user,user)
        end
      end
    end
    
    unless @report.sharedreports.nil?
      @list_of_remove_users = @report.sharedreports.collect {|sharedreport| [sharedreport.shared_user.print_name_with_association,sharedreport.id]}
      @list_of_remove_users.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @remove_users_list_size = [[@list_of_remove_users.size,15].min,5].max
    else
      @list_of_remove_users = Array.new
    end
    render :partial => 'remove_users_selector'
  end
  
  def remove_selected_users
    @report = Report.find_by_id(params[:id])

    params[:remove_users_list].each do |sharedreport_id|
      delete_with_audits('Sharedreport',sharedreport_id)
    end
    
    unless @report.sharedreports.nil?
      @list_of_remove_users = @report.sharedreports.collect {|sharedreport| [sharedreport.shared_user.print_name_with_association,sharedreport.id]}
      @list_of_remove_users.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @remove_users_list_size = [[@list_of_remove_users.size,15].min,5].max
    else
      @list_of_remove_users = Array.new
    end
    render :partial => 'remove_users_selector'
  end
  
  private
  
  def get_list_of_ntp_owners(shared_users)
    ntp_owner_array = Array.new
    User.find(:all).each do |user|
      user.networktermptowners.each do |owner|
        ntp_owner_array << [owner.name,"#{owner.id}"] if !ntp_owner_array.include?([owner.name, "#{owner.id}"]) and !in_shared_users?(shared_users,user.id) and user.id != session[:user_id] 
      end  
    end
    ntp_owner_array.sort {|x,y| x[0] <=> y[0]}
  end
  
  def get_list_of_pois(shared_users)
    poi_array = Array.new
    User.find(:all).each do |user|
      user.pointsofinterests.each do |poi|
        poi_array << [poi.name,"#{poi.id}"] if !poi_array.include?([poi.name,"#{poi.id}"]) and !in_shared_users?(shared_users,user.id) and user.id != session[:user_id]
      end
    end
    poi_array.sort {|x,y| x[0] <=> y[0]}
  end
  
  def get_list_of_nps(shared_users)
    np_array = Array.new
    User.find(:all).each do |user|
      user.networkproviders.each do |np|
        np_array << [np.name,"#{np.id}"] if !np_array.include?([np.name,"#{np.id}"]) and !in_shared_users?(shared_users,user.id) and user.id != session[:user_id]
      end
    end
    np_array.sort {|x,y| x[0] <=> y[0]}
  end
  
  def in_shared_users?(shared_users,user_id)
    shared_users.each {|shared_user| return true if "#{shared_user.id}" == "#{user_id}" }
    return false
  end
  
  def has_shared_report?(shared_reports,report_id)
    shared_reports.each {|shared_report| return true if "#{shared_report.report_id}" == "#{report_id}" }
    return false
  end
  
  def set_edit_report_variables(report)
    @selected_ntp_owners = session[:selected_networktermptowner_ids]
    @selected_pois = session[:selected_pois]
    @selected_nps = session[:selected_nps]
    @list_of_ntp_owners = get_list_of_ntp_owners(@report.shared_users)
    @list_of_pois = get_list_of_pois(@report.shared_users)
    @list_of_nps = get_list_of_nps(@report.shared_users)
    @selected_ntp_owners.delete_if {|x| !opt_list_contains_id(@list_of_ntp_owners,x) } if @selected_ntp_owners != nil
    @selected_pois.delete_if {|x| !opt_list_contains_id(@list_of_pois,x) } if @selected_pois != nil
    @selected_nps.delete_if {|x| !opt_list_contains_id(@list_of_nps,x) } if @selected_nps != nil
    
    unless @selected_ntp_owners.blank?
      @list_of_users_with_ntp_owners = Array.new
      UserNtpOwner.find(:all,:conditions => ["networktermptowner_id in (:id_list)", {:id_list => @selected_ntp_owners}]).each do |user_ntp_owner|
        @list_of_users_with_ntp_owners << user_ntp_owner.user if !user_ntp_owner.user.nil? and !has_shared_report?(user_ntp_owner.user.sharedreports,params[:id]) and user_ntp_owner.user_id != session[:user_id]
      end
    end  
    
    unless @selected_pois.blank?
      @list_of_users_with_pois = Array.new
      UserPoi.find(:all,:conditions => ["pointsofinterest_id in (:id_list)", {:id_list => @selected_pois}]).each do |user_poi|
        @list_of_users_with_pois << user_poi.user if !user_poi.user.nil? and !has_shared_report?(user_poi.user.sharedreports,params[:id]) and user_poi.user_id != session[:user_id]
      end
    end
  
    unless @selected_nps.blank?
      @list_of_users_with_nps = Array.new
      UserNp.find(:all,:conditions => ["networkprovider_id in (:id_list)", {:id_list => @selected_nps}]).each do |user_np|
        @list_of_users_with_nps << user_np.user if !user_np.user.nil? and !has_shared_report?(user_np.user.sharedreports,params[:id]) and user_np.user_id != session[:user_id]
      end
    end
  end
  
  def set_view_saved_reports_variables
    @list_of_saved_reports = @current_user.reports.sort {|x,y| x.report_title.downcase <=> y.report_title.downcase}
    @list_of_users_and_other_reports = Array.new
    hash_of_users_and_other_reports = Hash.new
    Sharedreport.find(:all,:conditions => "user_id = #{@current_user.id}").each do |shared_report|
      hash_of_users_and_other_reports[shared_report.report.user_id] = Array.new if hash_of_users_and_other_reports[shared_report.report.user_id] == nil
      hash_of_users_and_other_reports[shared_report.report.user_id] << shared_report
    end
    hash_of_users_and_other_reports.each_pair do |user_id, shared_reports|
      @list_of_users_and_other_reports << {:user => User.find_by_id(user_id), :shared_reports => shared_reports.sort {|x,y| x.report.report_title <=> y.report.report_title}}
    end
    @list_of_users_and_other_reports.sort! {|x,y| x[:user].print_name <=> y[:user].print_name }
  end
  
  def set_new_vars
    list_of_params = @reporttype.expected_parameters.split(',')
    @list_of_parameters = Array.new
    list_of_params.each do |param|
      if session[eval(":#{param}")].instance_of? Array then
        @list_of_parameters << {:key => param, :value => "["+(session[eval(":#{param}")].select {|val| !val.blank? }).join(',')+"]"}
      else
        @list_of_parameters << {:key => param, :value => session[eval(":#{param}")]}
      end
    end
  end  
  
  def set_json_vars
    @model = ReportsWithUser
    set_yui_vars('reports')
    #set_yui_vars
    @export_csv = false
    @order_by = "#{@table_name}.report_title"
    @where = "user_id = #{@current_user.id}"
    @columns = [
      { :name => "open_report", :type => "string", :label => "View", :sortable => false, :link_type => "open_report" },
      { :name => "report_title", :type => "string", :label => "Title", :sortable => true },
      { :name => "type_title", :type => "text", :label => "Type", :sortable => true },
      { :name => "owner", :type => "string", :label => "Owner", :sortable => true },
      { :name => "shared_with", :type => "string", :label => "Shared With", :sortable => true },
      { :name => "notes", :type => "text", :label => "Notes", :sortable => true },
      { :name => "edit", :type => "string", :label => "Edit", :sortable => false, :link_type => "edit" },
      { :name => "share", :type => "string", :label => "Share", :sortable => false, :link_type => "share_report" },
      { :name => "destroy", :type => "string", :label => "Delete", :sortable => false, :link_type => "destroy" },
      { :name => "id", :type => "integer", :hidden => true }
    ]
  end

  def list_of_users_from_search
    user_ids = Array.new
    if params[:search] and params[:search][:networktermptowner_id] == "All" then
      user_ids += UserNtpOwner.find(:all).collect {|association| association.user_id}
    elsif params[:search] and params[:search][:networktermptowner_id] != "None" then
      user_ids += UserNtpOwner.find(:all,
                                    :conditions => ["networktermptowner_id = :ntp_owner_id", 
                                                    {:ntp_owner_id => params[:search][:networktermptowner_id]}]).collect {|association| association.user_id}
    end
    if params[:search] and params[:search][:networkprovider_id] == "All" then
      user_ids += UserNp.find(:all).collect {|association| association.user_id}
    elsif params[:search] and params[:search][:networkprovider_id] != "None" then
      user_ids += UserNp.find(:all,
                              :conditions => ["networkprovider_id = :networkprovider_id", 
                                              {:networkprovider_id => params[:search][:networkprovider_id]}]).collect {|association| association.user_id}
    end
    if params[:search] and params[:search][:pointsofinterest_id] == "All" then
      user_ids += UserPoi.find(:all).collect {|association| association.user_id}
    elsif params[:search] and params[:search][:pointsofinterest_id] != "None" then
      user_ids += UserPoi.find(:all,
                               :conditions => ["pointsofinterest_id = :pointsofinterest_id", 
                                               {:pointsofinterest_id => params[:search][:pointsofinterest_id]}]).collect {|association| association.user_id}
    end
    if params[:search] and params[:search][:customer_group_id] == "All" then
      user_ids += UserCustomerGroup.find(:all).collect {|association| association.user_id}
    elsif params[:search] and params[:search][:customer_group_id] != "None" then
      user_ids += UserCustomerGroup.find(:all,
                               :conditions => ["customer_group_id = :customer_group_id", 
                                               {:customer_group_id => params[:search][:customer_group_id]}]).collect {|association| association.user_id}
    end
    user_ids.uniq!
    return nil if user_ids.size == 0
    users = user_ids.collect {|user_id| User.find_by_id(user_id)}
    users.delete_if {|user| user == nil}
    return users
  end
end
