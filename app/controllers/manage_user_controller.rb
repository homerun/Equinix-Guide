class ManageUserController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  before_filter :authorize, :except => [:confirm_email, :preferences]
  before_filter :check_administrator_role, :except => [:confirm_email, :preferences]
  
  def index
    set_json_vars
  end

  def json
    set_json_vars
    render :text => get_yui_hash(@model, @table_name, @columns, @order_by, @where).to_json
  end
  
  def destroy
    user = User.find_by_id(params[:id])
    user.active = 'D'
    user.save!
    flash[:notice] = "User (#{user.print_name}) deleted."
    redirect_to :action => :index
  end
  
  def show_users
    @user_list = get_user_list
    if params[:sort_by].blank? then
      @user_list.sort! {|x,y| x.print_name <=> y.print_name}
    else
      @user_list.sort! {|x,y| eval("x.#{params[:sort_by]}") <=> eval("y.#{params[:sort_by]}") }
    end
    render :partial => 'user_list'
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    if request.post? then
      begin
        # Add Network Termination Point Owner Associations
        @user.user_ntp_owners.each {|ntp_o| delete_with_audits('UserNtpOwner',ntp_o.id) unless params[:user_ntp_owner_networktermptowner_id].include?("#{ntp_o.networktermptowner_id}")} unless @user.user_ntp_owners.nil?
        params[:user_ntp_owner_networktermptowner_id].each do |ntp_owner_id|
          create_with_audits('UserNtpOwner',{:user_id => @user.id, :networktermptowner_id => ntp_owner_id}) unless ntp_owner_id.blank? or (@user.networktermptowners.collect {|ntp_o| ntp_o.id}).include?(ntp_owner_id.to_i) unless ntp_owner_id.blank? or ntp_owner_id.to_i == 0
        end if !params[:user_ntp_owner_networktermptowner_id].nil?
        
        # Add Network Provider Associations
        @user.user_nps.each {|np| delete_with_audits('UserNp',np.id) unless params[:user_np_networkprovider_id].include?("#{np.networkprovider_id}")} unless @user.user_nps.nil?
        params[:user_np_networkprovider_id].each do |networkprovider_id|
          create_with_audits('UserNp',{:user_id => @user.id, :networkprovider_id => networkprovider_id}) unless networkprovider_id.blank? or (@user.networkproviders.collect {|np| np.id}).include?(networkprovider_id.to_i) unless networkprovider_id.blank? or networkprovider_id.to_i == 0
        end if !params[:user_np_networkprovider_id].nil?
        
        # Add Points of Interest Associations
        @user.user_pois.each {|poi| delete_with_audits('UserPoi',poi.id) unless params[:user_poi_pointsofinterest_id].include?("#{poi.pointsofinterest_id}")} unless @user.user_pois.nil?
        params[:user_poi_pointsofinterest_id].each do |pointsofinterest_id|
          create_with_audits('UserPoi',{:user_id => @user.id, :pointsofinterest_id => pointsofinterest_id}) unless pointsofinterest_id.blank? or (@user.pointsofinterests.collect {|poi| poi.id}).include?(pointsofinterest_id.to_i) unless pointsofinterest_id.blank? or pointsofinterest_id.to_i == 0
        end if !params[:user_poi_pointsofinterest_id].nil?
        
        # Add Customer Security Group Associations
        @user.user_customer_groups.each {|grp| delete_with_audits('UserCustomerGroup',grp.id) unless params[:user_customer_group_id].include?("#{grp.customer_group_id}")} unless @user.user_customer_groups.nil?
        params[:user_customer_group_id].each do |customer_group_id|
          create_with_audits('UserCustomerGroup',{:user_id => @user.id, :customer_group_id => customer_group_id}) unless customer_group_id.blank? or (@user.user_customer_groups.collect {|grp| grp.id}).include?(customer_group_id.to_i) unless customer_group_id.blank? or customer_group_id.to_i == 0
        end if !params[:user_customer_group_id].nil?
        
        update_with_audits('User',params[:user])
        
        flash[:notice] = "User (#{@user.first_name + ' ' + @user.last_name}) successfully edited."
        
        redirect_to :action => :index
      rescue Exception => error
        if error.to_s[0..28] =='Mysql::Error: Duplicate entry'
          flash[:notice] = "User with email (#{@user.email}) already exists!"
        else
          flash[:notice] = "Error in saving: #{error}"
        end
      end
    end
    @list_of_pois = Pointsofinterest.find(:all, :order => "name").collect {|poi| ["#{poi.name}","#{poi.id}"]}
    @list_of_ntp_owners = Networktermptowner.find(:all, :order => "name").collect {|o| ["#{o.name}","#{o.id}"]}
    @list_of_nps = Networkprovider.find(:all, :order => "name").collect {|np| ["#{np.name}","#{np.id}"]}
    @list_of_roles = Role.find(:all, :order => "name").collect {|role| ["#{role.name} - #{role.description}","#{role.id}"]}
    @list_of_customer_groups = CustomerGroup.find(:all,:order => "name").collect {|cust_grp| ["#{cust_grp.name}","#{cust_grp.id}"]}
    @list_of_roles.delete_if {|x| x[1] == '1'} if @current_user.role_id != 1
    @list_of_ntp_owners.insert(0,['None','none'])
    @list_of_pois.insert(0,['None','none'])
    @list_of_nps.insert(0,['None','none'])
    @list_of_customer_groups.insert(0,['None',''])
  end
  
  def set_user_list
    users = Array.new
    all_users = User.find(:all)
    return all_users if params[:search].nil? or params[:search].blank?
    all_users.each do |user|
      add = false
      user.pointsofinterests.each do |poi|
        add = true unless poi.name[params[:search]].nil?
      end unless add or user.pointsofinterests.nil?
      user.networkproviders.each do |np|
        add = true unless np.name[params[:search]].nil?
      end unless add or user.networkproviders.nil?
      user.networktermptowners.each do |ntp_o|
        add = true unless ntp_o.name[params[:search]].nil?
      end unless add or user.networktermptowners.nil?
      add = true unless role.name[params[:search]].nil?
      add = true unless user.print_name[params[:search]].nil?
      users << user if add
    end
    return users
  end
  
  def add_user
    @subnav = "add_user"
    session[:original_uri] = request.request_uri
    session[:page] = 'add_user'
    if request.post? then
      params[:user][:password] = 'confirm_email_please'
      params[:user][:active] = 'R'
      params[:user][:email] = params[:user][:email].downcase
      begin
        @user = create_with_audits('User',params[:user])
        
        flash[:notice] = ''
        
        # Add Network Termination Point Owner Associations
        params[:user_ntp_owner_networktermptowner_id].each do |ntp_owner_id|
          create_with_audits('UserNtpOwner',{:user_id => @user.id, :networktermptowner_id => ntp_owner_id}) if !ntp_owner_id.blank?
        end if !params[:user_ntp_owner_networktermptowner_id].nil?
        
        # Add Network Provider Associations
        params[:user_np_networkprovider_id].each do |networkprovider_id|
          create_with_audits('UserNp',{:user_id => @user.id, :networkprovider_id => networkprovider_id}) if !networkprovider_id.blank?
        end if !params[:user_np_networkprovider_id].nil?
        
        # Add Points of Interest Associations
        params[:user_poi_pointsofinterest_id].each do |pointsofinterest_id|
          create_with_audits('UserPoi',{:user_id => @user.id, :pointsofinterest_id => pointsofinterest_id}) if !pointsofinterest_id.blank?
        end if !params[:user_poi_pointsofinterest_id].nil?
        
        # Add Customer Security Group Associations
        params[:user_customer_group_id].each do |customer_group_id|
          create_with_audits('UserCustomerGroup',{:user_id => @user.id, :customer_group_id => customer_group_id}) if !customer_group_id.blank?
        end if !params[:user_customer_group_id].nil?
        
        flash[:notice] += "User (#{@user.first_name + ' ' + @user.last_name}) successfully added!"
        
        emailRegistrationValues = {
          :user_id => @user.id, 
          :email_id => hash_email(params[:user][:email]), 
          :expiration_date => (Date.today + 14), 
          :reset => false, 
          :operating_user_id => session[:user_id]
        } 
        @email_registration = create_with_audits('Emailregistration',emailRegistrationValues)
        session[:email_registration] = @email_registration
        operating_user = User.find_by_id(session[:user_id])
        UserMailer.deliver_newuser(@email_registration,operating_user)
        flash[:notice] += " And email sent to user!"
        redirect_to :action => :new_user_email
      rescue Exception => error
        if error.to_s[0..28] =='Mysql::Error: Duplicate entry'
          flash[:notice] = "User with email (#{@user.email}) already exists!"
        else
          flash[:notice] = "Error in saving: #{error}"
        end
      end
    end
    @list_of_pois = Pointsofinterest.find(:all, :order => "name").collect {|poi| ["#{poi.name}","#{poi.id}"]}
    @list_of_ntp_owners = Networktermptowner.find(:all, :order => "name").collect {|o| ["#{o.name}","#{o.id}"]}
    @list_of_nps = Networkprovider.find(:all, :order => "name").collect {|np| ["#{np.name}","#{np.id}"]}
    @list_of_roles = Role.find(:all, :order => "name").collect {|role| ["#{role.name} - #{role.description}","#{role.id}"]}
    @list_of_customer_groups = CustomerGroup.find(:all,:order => "name").collect {|cust_grp| ["#{cust_grp.name}","#{cust_grp.id}"]}
    @list_of_roles.delete_if {|x| x[1] == '1'} if @current_user.role_id != 1
    @list_of_ntp_owners.insert(0,['None',''])
    @list_of_pois.insert(0,['None',''])
    @list_of_nps.insert(0,['None',''])
    @list_of_customer_groups.insert(0,['None',''])
  end
  
  def send_email_again
    if params[:emailRegistrationId] == nil then
      @user = User.find_by_id(params[:user_id])
      emailRegistrationValues = {
        :user_id => @user.id, 
        :email_id => hash_email(@user.email), 
        :expiration_date => (Date.today + 14), 
        :reset => false, 
        :operating_user_id => session[:user_id]
      } 
      @email_registration = create_with_audits('Emailregistration',emailRegistrationValues)
    else
      @email_registration = Emailregistration.find_by_id(params[:emailRegistrationId])
    end
    session[:email_registration] = @email_registration
    operating_user = User.find_by_id(session[:user_id])
    UserMailer.deliver_newuser(@email_registration,operating_user)
    render :text => "Email Sent Again."
  end
  
  def reset_password
    session[:user_id] = nil
    @current_user = nil
    if params[:user] == nil or params[:user][:email] == nil then
      render :text => 'You must enter your email first.' and return
    end
    user = User.find_by_email(params[:user][:email])
    if user == nil then
      render :text => 'Unrecognized Email.' and return
    end
    emailRegistration = Emailregistration.find(:first,:conditions => ["email_id = :email_id and used <> true and expiration_date >= :currentDate",
                                                                      {:email_id => hash_email(params[:user][:email]), :currentDate => Date.today}])
    unless emailRegistration.blank?
      render :text => "Email already sent. It will expire on #{emailRegistration.expiration_date}." and return
    end
    emailRegistrationValues = {
      :user_id => user.id, 
      :email_id => hash_email(user.email), 
      :expiration_date => (Date.today + 1), 
      :reset => true, 
      :operating_user_id => session[:user_id]
    } 
    @email_registration = create_with_audits('Emailregistration',emailRegistrationValues)
    session[:email_registration] = @email_registration
    UserMailer.deliver_reset_password_email(@email_registration)
    render :text => "An email allowing you to reset your password has been sent."
  end
  
  def new_user_email
    @confirmation_id = session[:email_registration].email_id
    @first_name = session[:email_registration].user.first_name
    @last_name = session[:email_registration].user.last_name
    @email_address = session[:email_registration].user.email
    @operating_user = User.find_by_id(session[:user_id])
  end
  
  def reset_password_email
    @confirmation_id = session[:email_registration].email_id
    @first_name = session[:email_registration].user.first_name
    @last_name = session[:email_registration].user.last_name
    @operating_user = User.find_by_id(session[:user_id])
  end

  def unregistered_users
    @subnav = "unregistered_users"
    session[:original_uri] = request.request_uri
    session[:page] = 'unregistered_users'
    @list_of_user_info = Array.new
    User.find(:all, :conditions => "active = 'R'").each do |user|
      # this works unless the current user has multiple connections. This will probably need to be done differently.
      if @current_user.is_equinix_user? || (user.networktermptowners.collect{|o| o.id}.join(',').include?(@current_user.networktermptowners.collect{|o| o.id}.join(',')) unless @current_user.networktermptowners.empty? && user.networktermptowners.empty?) || (user.networkproviders.collect{|np| np.id}.join(',').include?(@current_user.networkproviders.collect{|np| np.id}.join(',')) unless @current_user.networkproviders.empty? && user.networkproviders.empty?) || (user.pointsofinterests.collect{|p| p.id}.join(',').include?(@current_user.pointsofinterests.collect{|p| p.id}.join(',')) unless @current_user.pointsofinterests.empty? && user.pointsofinterests.empty?)
        @list_of_user_info << {:user => user, :emailRegistration => Emailregistration.find(:first, :conditions => "user_id = #{user.id} and expiration_date >= '#{Date.today}' and used = #{false}")}
      end
    end
    @list_of_user_info.sort! {|x,y| x[:user].print_name.downcase <=> y[:user].print_name.downcase}
  end
  
  
  def confirm_email
    session[:user_id] = nil
    @current_user = nil
    session[:original_uri] = request.request_uri
    session[:page] = 'confirm_email'
    if request.post? then
      @emailRegistration = Emailregistration.find_by_id(params[:user][:emailRegistrationId])
      if params[:user][:password] != params[:user][:password_confirmation] then
        @user = User.find_by_id(params[:user][:id])
        flash[:notice] = 'Passwords do not match!'
        return
      elsif params[:user][:password].blank?
        @user = User.find_by_id(params[:user][:id])
        flash[:notice] = 'Passwork cannot be blank!'
        return
      else
        params[:user][:active] = 'Y'
        emailRegistration = Emailregistration.find_by_id(params[:user][:emailRegistrationId])
        params[:user].delete('emailRegistrationId')
        begin
          @user = update_with_audits('User',params[:user])
          if emailRegistration.reset == true then
            flash[:notice] = "Password changed!"
          else
            flash[:notice] = "User (#{@user.first_name + ' ' + @user.last_name}) successfully registered!"
          end
          Emailregistration.update(emailRegistration.id,{:used => true})
          session[:user_id] = @user.id
          @current_user = @user
          redirect_to :controller => 'salesinfo', :action => "home" 
        rescue Exception => error
          flash[:notice] = "Error in saving: #{error}"
        end
      end
    else
      @emailRegistration = Emailregistration.find(:first,:conditions => ["email_id = :id and expiration_date >= :currentDate and used = false", {:id => params[:id], :currentDate => Date.today}])
      if @emailRegistration == nil then
        @message = "The link you used has expired or already been used."
      else
        @user = User.find_by_id(@emailRegistration.user_id)
      end
    end
  end
  
  
  def preferences
    session[:original_uri] = request.request_uri
    session[:page] = 'preferences'
    if request.post? then
      begin
        if !params[:user][:password].blank? and params[:user][:password] != params[:user][:password_confirmation] then
          flash[:notice] = 'Passwords do not match!'
        else
          if params[:user][:password].blank? then
            params[:user].delete('password')
            params[:user].delete('password_confirmation')
          end
          update_with_audits('User',params[:user])
          flash[:notice] = 'Successfully updated!'
        end
      rescue Exception => error
        flash[:notice] = "Error in saving: #{error}"
      end
    end
    @user = User.find_by_id(session[:user_id])
    redirect_to :controller => :login, :action => :login and return if @user.nil?
  end
  
  
  
  def set_modified
    @modified = true
    render :partial => '/shared/modified', :layout => false
  end
  
  
  def login_as
    if @current_user.is_super? then
      session[:user_id] = params[:id]
      @current_user = User.find_by_id(params[:id])
      flash[:notice] = "You are now logged in as #{@current_user.print_name_with_association}"
    else
      flash[:notice] = "You do not have sufficient privileges to login as another user."
    end
    redirect_to :controller => :salesinfo, :action => :home
  end
  
  private
  
  def set_json_vars
    @model = UsersWithAssociation
    set_yui_vars('manage_user')
    @export_csv = false
    @order_by = "#{@table_name}.last_name"
    @where = "status <> 'Deleted' and status <> 'Deleted'"
    @columns = [
      { :name => "last_name", :type => "string", :label => "Last Name", :sortable => true },
      { :name => "first_name", :type => "string", :label => "First Name", :sortable => true },
      { :name => "email", :type => "string", :label => "Email", :sortable => true },
      { :name => "role_name", :type => "string", :label => "Role", :sortable => true },
      { :name => "ntp_o_associations", :type => "text", :label => "Associations with Network Termination Point Owners", :sortable => true },
      { :name => "np_associations", :type => "text", :label => "Associations with Network Providers", :sortable => true },
      { :name => "poi_associations", :type => "text", :label => "Associations with Points of Interests", :sortable => true },
      { :name => "status", :type => "string", :label => "Status", :sortable => true },
      { :name => "edit", :type => "string", :label => "Edit", :sortable => false, :link_type => "edit" },
      { :name => "destroy", :type => "string", :label => "Delete", :sortable => false, :link_type => "destroy" },
      { :name => "id", :type => "integer", :hidden => true }
    ]
    @columns << {:name => 'login', :type => "string", :label => 'Login As...', :sortable => false, :link_type => "login" } if @current_user.is_super?
  end
  
  def check_administrator_role
    user = User.find_by_id(session[:user_id])
    if user.role_id != 1 and user.role_id != 2 then
      flash[:notice] = 'You do not have permission to manage users!'
      if session[:original_uri] == nil then
        redirect_to '/salesinfo/' and return
      end
      redirect_to session[:original_uri] and return
    end
  end
  
end
