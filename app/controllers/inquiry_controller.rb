class InquiryController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  before_filter :inquiry_authorize, :only => :respond_to_inquiries
  before_filter :authorize, :except => [:respond_to_inquiries, :submit_latency_time_inquiry_response, :submit_np2ntp_inquiry_response]
  before_filter :check_editor_role, :except => [:respond_to_inquiries, :submit_latency_time_inquiry_response, :submit_np2ntp_inquiry_response]

  def create_np2ntp_inquiry(ntp_id, np_id, inquiry_type)
    fieldValues = {:creator_id => @current_user.id, :networkterminationpoint_id => ntp_id, :networkprovider_id => np_id, :inquiry_type => inquiry_type}
    inquiry = create_with_audits('InquiryNp2ntp',fieldValues)
    inquiry.save!
  end

  def create_latency_time_inquiry(triple_id)
    a_np2ntp_id, networkprovider_id, b_np2ntp_id = triple_id.split('_')
    
    current_latency_time = Latencytime.find(:first,:conditions => "a_np2ntp_id = #{[a_np2ntp_id,b_np2ntp_id].min} and b_np2ntp_id = #{[a_np2ntp_id,b_np2ntp_id].max} and networkprovider_id = #{networkprovider_id}")
    first_inquiry = InquiryLatencyTime.find(:first,:conditions => "a_np2ntp_id = #{[a_np2ntp_id,b_np2ntp_id].min} and b_np2ntp_id = #{[a_np2ntp_id,b_np2ntp_id].max} and networkprovider_id = #{networkprovider_id}")
    inquiry_type = "#{((current_latency_time.nil?)?('I'):('V'))}#{((first_inquiry.nil?)?('F'):('A'))}"
    
    fieldValues = {:creator_id => @current_user.id, :a_np2ntp_id => a_np2ntp_id, :networkprovider_id => networkprovider_id, :b_np2ntp_id => b_np2ntp_id, :inquiry_type => inquiry_type}
    inquiry = create_with_audits('InquiryLatencyTime',fieldValues)
    inquiry.save!
  end
  
  def add_inquiries_for_networkprovider
    @edit_page = params[:edit_page]
    @b_ntp = Networkterminationpoint.find_by_id(params[:b_ntp_id])
    @networkprovider = Networkprovider.find_by_id(params[:networkprovider_id])
    @selected_ntp = Networkterminationpoint.find_by_id(params[:networkterminationpoint_id])
    @return_edit_page_link = "<a href='#{BASE_URL}networkterminationpoints/edit/#{@selected_ntp.id}'>Return to editing #{@selected_ntp.name}</a>" if @edit_page == 'Networkterminationpoint'
    
    if request.post? then
      if @b_ntp.nil? and @networkprovider.nil? then
        params[:selected_inquiries].each do |np_id| 
          create_np2ntp_inquiry(@selected_ntp.id, np_id, 'IA') unless np_id.blank?
        end
      else # latency time inquiry submission
        params[:selected_inquiries].each do |triple_id| # triple is the combination Anp2ntpID_NetworkProviderID_Bnp2ntpID combination
          create_latency_time_inquiry(triple_id) unless triple_id.blank?
        end
      end
      redirect_to :action => :send_inquiries_to_networkprovider, :id => @selected_ntp.id and return
    end
    
    # if it is an inquiry about a connection the networkprovider will not be known 
    #  and there is no second network termination point, so list all network providers
    #  that the first ntp can connect to
    if @b_ntp.nil? and @networkprovider.nil? then
      @inquiry_type_name = "Connectivity"
      @inquiry_type_identifier = "Connection"
      @list_of_inquiry_objs = Array.new
      Networkprovider.find(:all).each do |np|
        current_inquiries = InquiryNp2ntp.find(:all, :conditions => ["networkterminationpoint_id = :ntp_id and networkprovider_id = :np_id", {:ntp_id => @selected_ntp.id, :np_id => np.id}])
        latest_inquiry = nil
        current_inquiries.each do |np2ntp_inquiry|
          if latest_inquiry.nil? or np2ntp_inquiry.inquiry_id.blank? or latest_inquiry.inquiry.sent_at < np2ntp_inquiry.inquiry.sent_at then
            latest_inquiry = np2ntp_inquiry
            break if latest_inquiry.inquiry_id.blank?
          end
        end
        current_connections = @selected_ntp.connections_to(np.id)
        if current_connections.size > 0 then
          if current_connections.size > 1 then
            current_state = "Multiple connections of types:<br/>#{(current_connections.collect {|connection| connection.connectiontype.description}).join('<br/>')}"
          else
            current_state = current_connections[0].details
          end
          update_date_time = Audittrail.maximum(:created_at,:conditions => ["table_name = 'Np2ntp' and table_id in (:id_list)", {:id_list => current_connections.collect{|conneciton| id} }])
          update_audit = nil
          update_audit = Audittrail.find(:first,:conditions => ["table_name = 'Np2ntp' and table_id in (:id_list) and created_at = :created_at", {:id_list => current_connections.collect{|conneciton| id}, :created_at => update_date_time}]) if update_date_time != nil
          update_audit_user = User.find_by_id(update_audit.user_id) if update_audit != nil
          update_audit_user_name = ''
          update_audit_user_name = " - #{print_name_with_association(update_audit_user)}" if update_audit_user != nil
          last_update = "#{print_date(update_date_time)} #{update_audit_user_name}" if update_audit != nil
        else
          current_state = ''
          last_update = ''
        end
        @list_of_inquiry_objs << {:to_str => np.name, :current_state => current_state, :latest_inquiry => latest_inquiry, :last_update => last_update, :id => np.id}
      end
      
    # It's not an inquiry about network connectivity so it is about latency,
    #  if the second ntp (b_ntp) is null then they have selected the first ntp
    #  and the network provider, so list all the second ntps available for latency input
    elsif @b_ntp.nil? then
      @inquiry_type_name = "Latency Times"
      immediate_connections = @selected_ntp.connections_to(@networkprovider.id)
      if immediate_connections.size == 1 then
        @inquiry_type_identifier = "Connections<br/>to #{@selected_ntp.name}<br/>through #{@networkprovider.name}"
      else
        @inquiry_type_identifier = "Connections<br/>to #{@selected_ntp.name} (#{immediate_connections[0].connectiontype.name})<br/>through #{@networkprovider.name}"
      end
      @list_of_inquiry_objs = Array.new
      immediate_connections.each do |a_np2ntp|
        @selected_ntp.networkterminationpoint_connections_through(@networkprovider.id).each do |b_np2ntp|
          current_latency_time = Latencytime.find(:first,:conditions => "a_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].min} and b_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].max} and networkprovider_id = #{@networkprovider.id}")
          last_update = nil
          unless current_latency_time.nil?
            update_date_time = Audittrail.maximum(:created_at,:conditions => "table_name = 'Latencytime' and table_id = #{current_latency_time.id}")
            update_audit = nil
            update_audit = Audittrail.find(:first,:conditions => ["table_name = 'Latencytime' and table_id = #{current_latency_time.id} and created_at = :created_at", {:created_at => update_date_time}]) if update_date_time != nil
            last_update = "#{print_date(update_date_time)} #{update_audit.user.print_name_with_association unless update_audit.user.nil?}" unless update_audit.nil?
          end
          current_inquiries = InquiryLatencyTime.find(:all, :conditions => "a_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].min} and b_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].max} and networkprovider_id = #{@networkprovider.id}")
          latest_inquiry = nil
          current_inquiries.each do |latency_inquiry|
            if latest_inquiry.nil? or latency_inquiry.inquiry.nil? or latest_inquiry.inquiry.sent_at < latency_inquiry.inquiry.sent_at then
              latest_inquiry = latency_inquiry
              break if latest_inquiry.inquiry.nil?
            end
          end
          if immediate_connections.size == 1 then
            to_str = "#{b_np2ntp.networkterminationpoint.name} (#{b_np2ntp.connectiontype.name})"
          else
            to_str = "#{b_np2ntp.networkterminationpoint.name} (#{b_np2ntp.connectiontype.name}) to #{a_np2ntp.networkterminationpoint.name} (#{a_np2ntp.connectiontype.name})"
          end
          @list_of_inquiry_objs << {:to_str => to_str, 
                                    :current_state => ((current_latency_time.nil?)?(''):("#{current_latency_time.latency_time} ms")),
                                    :latest_inquiry => latest_inquiry,
                                    :last_update => last_update,
                                    :id => "#{[a_np2ntp.id,b_np2ntp.id].min}_#{@networkprovider.id}_#{[a_np2ntp.id,b_np2ntp.id].max}"}
        end
      end
      
    # It is not network connectivity, but latency times, and the first and second ntp are known
    #  so create a list of network providers that connect the two
    else #if @networkprovider.nil?
      @inquiry_type_name = "Latency Times"
      connecting_networkproviders = @selected_ntp.networkproviders_connecting_to(@b_ntp.id)
      if connecting_networkproviders.size == 0 then
        @inquiry_type_identifier = "No Network Providers Connect These Two!"
      else
        @inquiry_type_identifier = "Network Providers Connecting<br/>#{@selected_ntp.name} to #{@b_ntp.name}"
      end
      @list_of_inquiry_objs = Array.new
      connecting_networkproviders.each do |networkprovider|
        @selected_ntp.connections_to(networkprovider.id).each do |a_np2ntp|
          @b_ntp.connections_to(networkprovider.id).each do |b_np2ntp|
            current_latency_time = Latencytime.find(:first,:conditions => "a_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].min} and b_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].max} and networkprovider_id = #{networkprovider.id}")
            last_update = nil
            unless current_latency_time.nil?
              update_date_time = Audittrail.maximum(:created_at,:conditions => "table_name = 'Latencytime' and table_id = #{current_latency_time.id}")
              update_audit = nil
              update_audit = Audittrail.find(:first,:conditions => ["table_name = 'Latencytime' and table_id = #{current_latency_time.id} and created_at = :created_at", {:created_at => update_date_time}]) if update_date_time != nil
              last_update = "#{print_date(update_date_time)} #{update_audit.user.print_name_with_association unless update_audit.user.nil?}" unless update_audit.nil?
            end
            current_inquiries = InquiryLatencyTime.find(:all, :conditions => "a_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].min} and b_np2ntp_id = #{[a_np2ntp.id,b_np2ntp.id].max} and networkprovider_id = #{networkprovider.id}")
            latest_inquiry = nil
            current_inquiries.each do |latency_inquiry|
              if latest_inquiry.nil? or latency_inquiry.inquiry.nil? or latest_inquiry.inquiry.sent_at < latency_inquiry.inquiry.sent_at then
                latest_inquiry = latency_inquiry
                break if latest_inquiry.inquiry.nil?
              end
            end
            a_connection_str = ((@selected_ntp.connections_to(networkprovider.id).size > 1)?("(#{a_np2ntp.connectiontype.name}) "):(""))
            b_connection_str = ((@b_ntp.connections_to(networkprovider.id).size > 1)?(" (#{b_np2ntp.connectiontype.name})"):(""))
            @list_of_inquiry_objs << {:to_str => "#{a_connection_str}#{networkprovider.name}#{b_connection_str}", 
                                      :current_state => ((current_latency_time.nil?)?(''):("#{current_latency_time.latency_time} ms")),
                                      :latest_inquiry => latest_inquiry,
                                      :last_update => last_update,
                                      :id => "#{[a_np2ntp.id,b_np2ntp.id].min}_#{networkprovider.id}_#{[a_np2ntp.id,b_np2ntp.id].max}"}
          end
        end
      end
    end
    @list_of_inquiry_objs.sort! {|x,y| x[:to_str].downcase <=> y[:to_str].downcase}
  end

  def send_email_to_np
    np = Networkprovider.find_by_id(params[:networkprovider_id])
    if params[:inquiry] == nil or params[:inquiry][:send_to] == nil then
      email_address = params[:email_address]
      name = params[:name]
    elsif params[:inquiry][:send_to] == 'user_edit' then
      email_address = params[:email_address]
      name = params[:name]
    elsif params[:inquiry][:send_to] == 'user_select' then
      user = User.find_by_id(params[:user_list])
      email_address = user.email
      name = user.print_name
    elsif params[:inquiry][:send_to] == 'np_provided' then
      email_address = params[:np_email]
      name = params[:np_name]
    end 
    send_to_user = User.find_by_email(email_address)
    if name.blank? and email_address.blank? then
      flash[:notice] = "Name and Email cannot be blank!"
    elsif name.blank? then
      flash[:notice] = "Name cannot be blank!"
    elsif email_address.blank? then
      flash[:notice] = "Email cannot be blank!"
    elsif (params[:np2ntp_inquiries].nil? or params[:np2ntp_inquiries].size == 0) and (params[:latency_time_inquiries].nil? or params[:latency_time_inquiries].size == 0) then
      flash[:notice] = "No inquiries selected!"
    else
      if send_to_user == nil then
        names = name.split(' ')
        if names.size == 1 then
          first_name = 'Mr./Mrs.'
          last_name = name
        else
          first_name = names[0..(names.size-2)].join(' ')
          last_name = names[(names.size-1)]
        end
        send_to_user = create_with_audits('User',{:first_name => first_name,:last_name => last_name, :email => email_address, :role_id => 5, :active => 'R', :password => 'none'})      
      end
      unless send_to_user.associated_with_networkprovider?(np.id)
        create_with_audits('UserNp',{:networkprovider_id => np.id, :user_id => send_to_user.id})
      end
      inquiry_obj = create_with_audits('Inquiry',{:inquiry_sender_id => @current_user.id, :sent_at => Time.now, :inquire_to_email => email_address, :inquire_to_name => name, :inquire_to_user_id => send_to_user.id})
      inquiry_obj.save!
      params[:np2ntp_inquiries].each do |inquiry_np2ntp_id|
        inquiry_np2ntp = InquiryNp2ntp.find_by_id(inquiry_np2ntp_id)
        unless inquiry_np2ntp.nil?
          inquiry_np2ntp.inquiry_id = inquiry_obj.id 
          inquiry_np2ntp.save!
        end
      end unless params[:np2ntp_inquiries].nil?
      params[:latency_time_inquiries].each do |latency_time_inquiry_id|
        latency_time_inquiry = InquiryLatencyTime.find_by_id(latency_time_inquiry_id)
        unless latency_time_inquiry.nil?
          latency_time_inquiry.inquiry_id = inquiry_obj.id 
          latency_time_inquiry.save!
        end
      end unless params[:latency_time_inquiries].nil?
      UserMailer.deliver_inquiry_to_np(@current_user,name,email_address,inquiry_obj,send_to_user)
    end
    if flash[:notice] == nil or flash[:notice].blank? then
      render :text => "Email Sent." and return
    else
      render :text => "<script type='text/javascript'> window.location.reload(true); </script>" and return
    end
  end
  
  def discard_np_inquiry
    "#{params[:inquiries]}".split(',').each do |inquiryId|
      delete_with_audits('Inquiry',inquiryId)
    end
    if session[:page] == 'np_inquiry_manager' then 
      np = Networkprovider.find_by_id(params[:networkprovider_id])
      inquiries = Array.new
      Inquiry.find(:all,:conditions => ["inquire_to_table = 'Networkprovider' and inquire_to_table_id = :id",{:id => np.id}]).each do |inquiry|
        inquiries << inquiry
      end
      pending = Array.new
      sent = Array.new
      with_response = Array.new
      inquiries.each do |inquiry|
        if inquiry.inquiry_table == 'Networkterminationpoint' then
          inquiry_obj = Networkterminationpoint.find_by_id(inquiry.inquiry_table_id)
        else # if inquiry.inquiry_table == 'pointsofinterest' then
          inquiry_obj = Pointsofinterest.find_by_id(inquiry.inquiry_table_id)
        end
        pending << {:inquiry_obj => inquiry_obj, :inquiry_detail => inquiry} if inquiry.sent_at == nil
        sent << {:inquiry_obj => inquiry_obj, :inquiry_detail => inquiry} if inquiry.sent_at != nil and inquiry.response_date == nil
        with_reponse << {:inquiry_obj => inquiry_obj, :inquiry_detail => inquiry} if inquiry.sent_at != nil and inquiry.response_date != nil
      end
      np_obj = {:np => np, :pending => pending, :sent => sent, :with_response => with_response, :user_list => get_list_objs_for_users_with_np(np.id)}
      @not_hidden = true
      render :partial => 'np_inquiry_manager_table', :locals => {:np_obj => np_obj, :even => eval(params[:even])}
    else #if session[:page] 'edit_ntp' > inquire np about ntp
      render :text => "Inquiry Discarded." and return
    end
  end
  
  def send_inquiries_to_networkprovider
    @selected_ntp = Networkterminationpoint.find_by_id("#{params[:id]}")
    @list_of_np_objs = Array.new
    flash[:notice] = ''
    np_hash = Hash.new
    InquiryNp2ntp.find(:all,:conditions => ["networkterminationpoint_id = :ntp_id and inquiry_id is null", {:ntp_id => @selected_ntp.id}]).each do |inquiry|
      if np_hash[inquiry.networkprovider_id].nil? then
        np_hash[inquiry.networkprovider_id] = {:np => inquiry.networkprovider,
                                               :np2ntp_inquiries => InquiryNp2ntp.find(:all,:conditions => ["networkprovider_id = :np_id and inquiry_id is null", {:np_id => inquiry.networkprovider_id}]), 
                                               :latency_time_inquiries => InquiryLatencyTime.find(:all,:conditions => ["networkprovider_id = :np_id and inquiry_id is null", {:np_id => inquiry.networkprovider_id}]), 
                                               :user_list => get_list_objs_for_users_with_np(inquiry.networkprovider.id)}
      end
    end
    InquiryLatencyTime.find(:all,:joins => "left join np2ntps on (inquiry_latency_times.a_np2ntp_id = np2ntps.id or inquiry_latency_times.b_np2ntp_id = np2ntps.id)", :conditions => ["np2ntps.networkterminationpoint_id = :ntp_id and inquiry_latency_times.inquiry_id is null", {:ntp_id => @selected_ntp.id}], :select => "inquiry_latency_times.*").each do |inquiry|
      if np_hash[inquiry.networkprovider_id].nil? then
        np_hash[inquiry.networkprovider_id] = {:np => inquiry.networkprovider,
                                               :np2ntp_inquiries => InquiryNp2ntp.find(:all,:conditions => ["networkprovider_id = :np_id and inquiry_id is null", {:np_id => inquiry.networkprovider_id}]), 
                                               :latency_time_inquiries => InquiryLatencyTime.find(:all,:conditions => ["networkprovider_id = :np_id and inquiry_id is null", {:np_id => inquiry.networkprovider_id}]), 
                                               :user_list => get_list_objs_for_users_with_np(inquiry.networkprovider.id)}
      end
    end
    np_hash.each_pair {|key,value| @list_of_np_objs << value }
    @list_of_np_objs.sort! {|x,y| x[:np].name <=> y[:np].name}
  end
  
  def respond_to_inquiries
    unless params[:inquiry].blank? then
      user = User.find_by_id(params[:inquiry])
      if !user.nil? and user.hash_id("inquiry") == params[:id] then
        @current_user = user
      end
    end
    if @current_user != nil then
      @inquiries = Inquiry.find(:all,:conditions => ["inquire_to_user_id = :id and sent_at is not null", {:id => @current_user.id}], :order => 'sent_at DESC')
      @list_of_connection_types = get_list_of_connection_types
    end
  end
  
  def submit_np2ntp_inquiry_response
    np2ntp_inquiry = InquiryNp2ntp.find_by_id(params[:np2ntp_inquiry_id])
    @current_user = User.find_by_id(params[:user_id])
    if np2ntp_inquiry == nil then
      render :text => 'Error in response submission.' and return
    end
    current_connection = Np2ntp.find(:first,:conditions => ["networkprovider_id = :np_id and networkterminationpoint_id = :ntp_id", {:np_id => np2ntp_inquiry.networkprovider_id, :ntp_id => np2ntp_inquiry.networkterminationpoint_id}])
    if current_connection != nil then
      update_with_audits('Np2ntp',{:id => current_connection.id, :connectiontype_id => params[:connectiontype_id], :user_id => @current_user.id})
    else
      create_with_audits('Np2ntp',{:networkprovider_id => np2ntp_inquiry.networkprovider_id, :networkterminationpoint_id => np2ntp_inquiry.networkterminationpoint_id, :connectiontype_id => params[:connectiontype_id], :user_id => @current_user.id})
    end
    update_with_audits('InquiryNp2ntp',{:id => np2ntp_inquiry.id, :response_date => Date.today, :response_connectiontype_id => params[:connectiontype_id]})
    render :text => 'Successfully Submitted.' and return
  end
  
  def submit_latency_time_inquiry_response
    latency_time_inquiry = InquiryLatencyTime.find_by_id(params[:latency_time_inquiry_id])
    @current_user = User.find_by_id(params[:user_id])
    if latency_time_inquiry == nil then
      render :text => 'Error in response submission.' and return
    end
    current_latency_time = Latencytime.find(:first,:conditions => "a_np2ntp_id = #{[latency_time_inquiry.a_np2ntp_id,latency_time_inquiry.b_np2ntp_id].min} and b_np2ntp_id = #{[latency_time_inquiry.a_np2ntp_id,latency_time_inquiry.b_np2ntp_id].max} and networkprovider_id = #{latency_time_inquiry.networkprovider_id}")
    if current_latency_time != nil then
      update_with_audits('Latencytime',{:id => current_latency_time.id, :latency_time => params[:latency_time_text], :user_id => @current_user.id})
    else
      create_with_audits('Latencytime',{:networkprovider_id => latency_time_inquiry.networkprovider_id, :a_np2ntp_id => latency_time_inquiry.a_np2ntp_id, :b_np2ntp_id => latency_time_inquiry.b_np2ntp_id, :latency_time => params[:latency_time_text], :user_id => @current_user.id})
    end
    update_with_audits('InquiryLatencyTime',{:id => latency_time_inquiry.id, :response_date => Date.today, :response_latency_time => params[:latency_time_text]})
    render :text => 'Successfully Submitted.' and return
  end
  
  
  
  private
  
  

  def inquiry_authorize
    if request.request_uri[0..28] != "/inquiry/respond_to_inquiries"
      authorize
    else
      the_user = User.find_by_id(params[:inquiry])
      return true if !the_user.nil? and !@current_user.nil? and @current_user.id == the_user.id
      if the_user.nil? or !the_user.is_contact?
        session[:original_uri] = request.request_uri
        flash[:notice] = "Please log in"
        redirect_to(:controller => "login", :action => "login") and return
      else
        @current_user = the_user
        session[:contact_only] = true
      end
      the_user.set_last_activity(request.remote_ip,'A')
    end
  end
  
  def check_url
    return true if request.request_uri[0..28] != "/inquiry/respond_to_inquiries"
    return true if session[:user_id] != nil and params[:id].nil?
    the_user = User.find_by_id(params[:inquiry])
    session[:user_id] = nil
    @current_user = nil
    unless the_user.nil?
      if the_user.active == 'R' or (the_user.active == 'Y' and "#{the_user.role_id}" == '5') then
        session[:user_id] = the_user.id
        @current_user = the_user
        session[:contact_only] = true
      else
        authorize
      end
    end
  end
  
  def check_editor_role
    user = User.find_by_id(session[:user_id])
    if user.role_id != 1 and user.role_id != 2 and user.role_id != 3 then
      flash[:notice] = 'You do not have permission to send or manage inquiries!'
      if session[:original_uri] == nil or session[:original_uri] == "#{request.request_uri}" then
        redirect_to '/salesinfo/poi_hosting_scorecard' and return
      end
      redirect_to session[:original_uri] and return
    end
  end
  
  def get_list_objs_for_users_with_np(networkprovider_id)
    users = UserNp.find(:all,:conditions => ["networkprovider_id = :np_id",{:np_id => networkprovider_id}])
    return nil if users.nil? or users.size == 0
    return users.collect {|user_np| ["#{user_np.user.print_name} (#{user_np.user.email})",user_np.user.id] }
  end
  
  def get_list_of_connection_types
    (Connectiontype.find(:all).map { |type| ["#{type.name} - #{type.type_description}", "#{type.id}"] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
    #(Connectiontype.find(:all).map { |type| ["#{type.name}", type.id] }).sort { |x,y| x[0].downcase <=> y[0].downcase }
  end
end
