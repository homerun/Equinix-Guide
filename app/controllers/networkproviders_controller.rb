require "pdf/writer"

class NetworkprovidersController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def index
    redirect_to :action => :edit
  end
  
  def new
    @networkprovider = Networkprovider.new
    @prev_params = Hash.new if @prev_params.nil?
    set_new_np_vars
  end
  
  def create
    @networkprovider = Networkprovider.new(params[:networkprovider])
    if @networkprovider.save
      flash[:notice] = 'Network Provider was successfully created.<br/>'
      params[:networkprovider][:id] = @networkprovider.id
      @networkprovider.user_contact_region1 = check_for_new_regional_np_contact(params,1)
      @networkprovider.user_contact_region2 = check_for_new_regional_np_contact(params,2)
      @networkprovider.user_contact_region3 = check_for_new_regional_np_contact(params,3)
      @networkprovider.user_contact_region4 = check_for_new_regional_np_contact(params,4)
      @networkprovider.save!
      Audittrail.new.create_new_audit(@current_user, "Networkprovider", @networkprovider.id)
      redirect_to :action => 'edit', :id => @networkprovider.id
    else
      @prev_params = params
      @prev_params = Hash.new if @prev_params.nil?
      render :action => 'new'
    end
  end
  
  def destroy
    begin
      delete_with_audits('Networkprovider',params[:id])
      session[:selected_networkprovider] = nil
    rescue Exception => error
      if error.to_s[0..26] != 'Mysql::Error: Cannot delete'
        flash[:notice] = "An unknown error occured: \"#{error}\""
      else
        np = Networkprovider.find_by_id(params[:id])
        flash[:notice] = "The Network Provider <i>#{np.name}</i> may not be deleted because it is associated with a Network Termination Point, Latency Time, or exists as a Preferred Network Provider for a Point of Interest. If you wish to delete this Network Provider, you must first remove all associations with this Network Provider."
      end
    end
    redirect_to :action => 'edit', :id => nil
  end
  
  def hello_world_pdf
    _pdf = PDF::Writer.new
    _pdf.left_margin = 0
    _pdf.top_margin = 0
    _pdf.select_font "Times-Roman"
    _pdf.stroke_color Color::RGB::Black
    _pdf.rectangle(0,_pdf.page_height-75,_pdf.page_width,75).fill
    _pdf.fill_color Color::RGB::Red
    _pdf.rectangle(0,_pdf.page_height-76,_pdf.page_width,1).fill
    _pdf.image("http://www.circuitclout.com/images/pdf_header.png")
    _pdf.move_to(10,10)
    _pdf.image("http://www.circuitclout.com/images/equinix_logo.png",:resize => 0.7, :justification => :right)
    _pdf.move_to(0,0)
    _pdf.fill_color Color::RGB::Black
    _pdf.text "Equinix.#{_pdf.page_width},#{_pdf.page_height}", :font_size => 32, :justification => :center

    send_data _pdf.render, :filename => "hello.pdf",
              :type => "application/pdf"
  end
  
  
  def check_for_new_regional_np_contact(parms,number)
    return if parms["region#{number}ContactEditName"].blank? and parms["region#{number}ContactEditEmail"].blank?
    if parms["region#{number}ContactEditEmail"].blank? then
      flash[:notice] += 'The new contact you entered has a blank email. Please enter the email before saving.<br/>'
      return nil
    end
    userContact = User.find_by_email(parms["region#{number}ContactEditEmail"])
    if userContact == nil then
      if parms["region#{number}ContactEditName"].blank? then
        flash[:notice] += 'The new contact you entered has a blank name. Please enter the name before saving.<br/>'
        return nil
      end
      names = parms["region#{number}ContactEditName"].split(' ')
      if names.size == 1 then
        first_name = 'Mr./Mrs.'
        last_name = parms["region#{number}ContactEditName"]
      else
        first_name = names[0..(names.size-2)].join(' ')
        last_name = names[(names.size-1)]
      end
      userContact = create_with_audits('User',{:first_name => first_name, :last_name => last_name, :email => parms["region#{number}ContactEditEmail"], :phone_number => parms["region#{number}ContactEditPhone"], :role_id => 5, :active => 'R', :password => 'none'})
    else
      unless userContact.associated_with_networkprovider?(params[:networkprovider][:id])
        create_with_audits('UserNp',{:networkprovider_id => params[:networkprovider][:id], :user_id => userContact.id})
      end
      flash[:notice] += "The email you entered is associated with a user currently in the database (#{userContact.print_name}). That user's name #{ 'and phone ' unless userContact.phone_number.blank? }information will be used.<br/>"
      userContact.phone_number = parms["region#{number}ContactEditPhone"] if userContact.phone_number.blank?
      update_with_audits('User',{:id => userContact.id, :phone_number => parms["region#{number}ContactEditPhone"]}) if userContact.phone_number != parms["region#{number}ContactEditPhone"]
    end
    parms[:networkprovider]["user_contact_region#{number}"] = userContact.id
    return userContact.id
  end
  
  def update
    flash[:notice] = ''
    if params[:networkprovider][:name].blank? then
      flash[:notice] += "Network Provider name cannot be blank. Renamed to '(No name)'.<br/>"
      params[:networkprovider][:name] = '(No name)' 
    end
    check_for_new_regional_np_contact(params,1)
    check_for_new_regional_np_contact(params,2)
    check_for_new_regional_np_contact(params,3)
    check_for_new_regional_np_contact(params,4)
    begin
      if params[:networkprovider][:id] == '' then
        @networkprovider = create_with_audits('Networkprovider',params[:networkprovider])
      else
        @networkprovider = update_with_audits('Networkprovider',params[:networkprovider])
      end
    rescue Exception => error
      if error.to_s[0..28] != 'Mysql::Error: Duplicate entry'
        flash[:notice] += "An unknown error occured: \"#{error}\""
      else
        flash[:notice] += "A Network Provider named '#{params[:networkprovider][:name]}' already exists! Use your internet browser's back button to recover changes."
      end
      redirect_to :action => 'edit', :id => nil and return
    end
    redirect_to :action => 'edit', :id => @networkprovider.id, :selected_tab_row => params[:current_tab_row], :selected_tab => params[:current_tab]
  end
  
  def edit
    @subnav = "nps"
    session[:original_uri] = request.request_uri
    session[:page] = 'edit_networkprovider'
    @selected_tab = params[:selected_tab]
    @selected_tab_row = params[:selected_tab_row]
    @page = session[:page]
    
    @selected_networkprovider = params[:id]
    session[:selected_networkprovider] = params[:id]

    @list_of_types = [['Carrier','C'],['Extranet','E'],['Optimized IP Routing','R']]
    @list_of_networkproviders = (Networkprovider.find(:all).collect {|np| [np.name,np.id] }).sort {|x,y| x[0].downcase <=> y[0].downcase }
    params[:id] = nil if !@current_user.can_view_page?('edit_networkprovider',params[:id])
    
    @networkprovider = Networkprovider.find_by_id(params[:id])
    if @networkprovider != nil then
      if @networkprovider.ntp_connections == nil then
        @other_ntp_connections = (Networkterminationpoint.find(:all).collect { |ntp| [ntp.name,ntp.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
      else
        @other_ntp_connections = ((Networkterminationpoint.find(:all).collect { |ntp| [ntp.name,ntp.id] }) - 
          (@networkprovider.ntp_connections.map { |ntp_connection| [ntp_connection.networkterminationpoint.name,ntp_connection.networkterminationpoint.id] unless ntp_connection.networkterminationpoint.nil?})).sort { |x,y| x[0].downcase <=> y[0].downcase }
      end
      @connection_types = (Connectiontype.find(:all).collect {|ct| [ct.type_description,ct.id]} ).sort {|x,y| x[0].downcase <=> y[0].downcase}
      @list_of_contacts = get_list_of_np_contacts(@networkprovider.id)
      news_associations = News2np.find(:all,:conditions => ["networkprovider_id = :id", {:id => @networkprovider.id}])
      @list_of_news = news_associations.collect {|x| x.newsitem }
      condition = 'carrier_type = 1'
      if @networkprovider.isp_type == true then
        @selected_type = 'I'
        condition = 'isp_type = 1'
      elsif @networkprovider.routing_type == true then
        @selected_type = 'R'
        condition = 'routing_type = 1'
      elsif @networkprovider.extranet_type == true then
        @selected_type = 'E'
        condition = 'extranet_type = 1'
      else #if @networkprovider.carrier_type == true then
        @selected_type = 'C'
        condition = 'carrier_type = 1'
      end
      @selected_np = @networkprovider.id
      @list_of_networkproviders = (Networkprovider.find(:all,:conditions => condition).collect{|np| [np.name,np.id]} ).sort {|x,y| x[0].downcase <=> y[0].downcase}
    end
  end
  
  def add_ntp_connection
    @change_to_edit = true
    fieldValues = {:networkterminationpoint_id => params[:selected_ntp][:id], :networkprovider_id => params[:np][:id], :connectiontype_id => params[:selected_connection_type][:connectiontype_id]}
    fieldValues[:user_id] = @current_user.id if @current_user.associated_with_networkprovider?(params[:np][:id])
    @ntp_connection = create_with_audits('Np2ntp',fieldValues)
    @networkprovider = Networkprovider.find_by_id(params[:np][:id])
    if @networkprovider.ntp_connections == nil then
      @other_ntp_connections = (Networkterminationpoint.find(:all).map { |ntp| [ntp.name,ntp.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
    else
      @other_ntp_connections = ((Networkterminationpoint.find(:all).map { |ntp| [ntp.name,ntp.id] }) - 
        (@networkprovider.ntp_connections.map { |ntp_connection| [ntp_connection.networkterminationpoint.name,ntp_connection.networkterminationpoint.id] })).sort { |x,y| x[0].downcase <=> y[0].downcase }
    end
    @connection_types = Connectiontype.find(:all,:order => 'type_description').collect {|ct| [ct.type_description,ct.id]}
    @can_edit_ntp_connections = 'yes'
    render(:partial => "networkprovider_networkterminationpoints", :layout => false) and return
  end
  
  def remove_ntp_connection
    @change_to_edit = true
    begin
      delete_with_audits('Np2ntp',params[:deleteId])
    rescue Exception => error
      if error.to_s[0..26] != 'Mysql::Error: Cannot delete'
        flash[:notice] = "An unknown error occured: \"#{error}\""
      else
        np = Np2ntp.find_by_id(params[:deleteId]).networkprovider
        flash[:notice] = "The connection with Network Provider <i>#{np.name}</i> may not be deleted because it is associated with one or more Latency Times. If you wish to remove the connection with this Network Provider, you must first remove any associated Latency Times."
      end
    end
    @networkprovider = Networkprovider.find_by_id(params[:id])
    if @networkprovider.ntp_connections == nil then
      @other_ntp_connections = (Networkterminationpoint.find(:all).map { |ntp| [ntp.name,ntp.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
    else
      @other_ntp_connections = ((Networkterminationpoint.find(:all).map { |ntp| [ntp.name,ntp.id] }) - 
        (@networkprovider.ntp_connections.map { |ntp_connection| [ntp_connection.networkterminationpoint.name,ntp_connection.networkterminationpoint.id] })).sort { |x,y| x[0].downcase <=> y[0].downcase }
    end
    @connection_types = Connectiontype.find(:all,:order => 'type_description').collect {|ct| [ct.type_description,ct.id]}
    @can_edit_ntp_connections = 'yes'
    render(:partial => "networkprovider_networkterminationpoints", :layout => false)
  end
  
  def certify_np2ntp_connection
    ntp_connection = Np2ntp.find_by_id(params[:id])
    render :text => 'Error in submission. Connection no longer exists.' and return if ntp_connection == nil
    update_with_audits('Np2ntp',{:id => ntp_connection.id, :user_id => @current_user.id, :certified_date => Date.today})
    render :text => 'Certified.'
  end
  
  def contest_np2ntp_connection
    ntp_connection = Np2ntp.find_by_id(params[:id])
    render :text => 'Error in submission. Connection no longer exists.' and return if ntp_connection == nil
    unless ntp_connection.user_id.nil? or ntp_connection.user_id == @current_user.id
      create_with_audits('ContestlistNp2ntp',{:np2ntp_id => ntp_connection.id, :user_id => @current_user.id, :connectiontype_id => params[:selected_connection_type_contest]})
      render :text => "Contested." and return
    end
    if @current_user.associated_with_networkprovider?(ntp_connection.networkprovider.id) then
      ntp_connection = update_with_audits('Np2ntp',{:id => ntp_connection.id, :user_id => @current_user.id, :connectiontype_id => params[:selected_connection_type_contest]})
      ntp_connection.save!
      render :text => "#{ntp_connection.details}<script type=\"text/javascript\">$('certified_connection_#{ntp_connection.id}').innerHTML = 'Yes';</script>" and return
    else
      ntp_connection = update_with_audits('Np2ntp',{:id => ntp_connection.id, :connectiontype_id => params[:selected_connection_type_contest]})
      ntp_connection.save!
      render :text => "#{ntp_connection.details}<script type=\"text/javascript\">$('certified_connection_#{ntp_connection.id}_a').innerHTML = 'Edit';</script>" and return
    end
  end
   
  def select_np
    if params[:select_np].blank? or params[:select_np] == "0"
      redirect_to :action => 'edit', :id => nil
    else
      redirect_to :action => 'edit', :id => params[:select_np]
    end
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
  
  def select_np_type
    unless params[:np_type] == '0'
      condition = 'carrier_type = 1'
      if params[:np_type] == "E" then
        condition = 'extranet_type = 1'
      elsif params[:np_type] == "R" then
        condition = 'routing_type = 1'
      else #if params[:np_type] == "C" then
        condition = 'carrier_type = 1'
      end
      @list_of_networkproviders = (Networkprovider.find(:all,:conditions => condition).collect{|np| [np.name,np.id]} ).sort {|x,y| x[0].downcase <=> y[0].downcase}
      @selected_np = params[:networkprovider_id] if !params[:networkprovider_id].blank?
      @selected_tab = (params[:selected_tab].blank? ? '1' : params[:selected_tab])
    else
      @list_of_networkproviders = (Networkprovider.find(:all).collect{|np| [np.name,np.id]} ).sort {|x,y| x[0].downcase <=> y[0].downcase}
    end
    render :partial => 'select_np'
  end  
  
  def set_new_np_vars
    @list_of_types = [['Carrier','C'],['Extranet','E'],['Optimized IP Routing','R']]
  end
  
end
