class Np2ntpsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def create
    @change_to_edit = true
    @np2ntp = Np2ntp.find(:first,:conditions => ["networkprovider_id = :npId and networkterminationpoint_id = :ntpId",
                                                  {:npId => params[:np2ntp][:networkprovider_id], :ntpId => params[:np2ntp][:networkterminationpoint_id]}])
    if @np2ntp.nil? then
      @np2ntp = Np2ntp.new(params[:np2ntp])
      if @np2ntp.save
        Audittrail.new.create_new_audit(@current_user, "Np2ntp", @np2ntp.id)
      end
    else
      if @np2ntp.connectiontype_id != params[:np2ntp][:connectiontype_id].to_i then
        @np2ntp = Np2ntp.new(params[:np2ntp])
        if @np2ntp.save
          Audittrail.new.create_new_audit(@current_user, "Np2ntp", @np2ntp.id)
        end
        flash[:notice] = "Warning: There already exists a Connection between this Network Provider and the Network Termination Point. However, because two connections with different connection types may exist, <i>the connection was saved successfully</i>. If this was done in error, correct the incorrect connection to delete the duplicate."
      else
        flash[:notice] = "Error: Duplicate Connection. Connection not added."
      end
    end
    
    @networkterminationpoint = Networkterminationpoint.find(params[:np2ntp][:networkterminationpoint_id])
    set_vars
    render :partial => "networkterminationpoints/network_providers"
  end
  
  def add
    @change_to_edit = true
    @np2ntp = Np2ntp.find(:first,:conditions => ["networkprovider_id = :npId and networkterminationpoint_id = :ntpId",
                                                  {:npId => params[:networkprovider_id], :ntpId => params[:networkterminationpoint_id]}])
    if @np2ntp.nil? then
      @np2ntp = Np2ntp.new(params[:np2ntp])
      if @np2ntp.save
        Audittrail.new.create_new_audit(@current_user, "Np2ntp", @np2ntp.id)
      end
    else
      if @np2ntp.connectiontype_id != params[:np2ntp][:connectiontype_id].to_i then
        @np2ntp = Np2ntp.new(params[:np2ntp])
        if @np2ntp.save
          Audittrail.new.create_new_audit(@current_user, "Np2ntp", @np2ntp.id)
        end
        flash[:notice] = "Warning: There already exists a Connection between this Network Provider and the Network Termination Point. However, because two connections with different connection types may exist, <i>the connection was saved successfully</i>. If this was done in error, correct the incorrect connection to delete the duplicate."
      else
        flash[:notice] = "Error: Duplicate Connection. Connection not added."
      end
    end
    
    @networkterminationpoint = Networkterminationpoint.find(params[:np2ntp][:networkterminationpoint_id])
    set_vars
    render :partial => "networkterminationpoints/network_providers"
  end
  
  def destroy
    np2ntp = Np2ntp.find(params[:id])
    @networkterminationpoint = np2ntp.networkterminationpoint
    Audittrail.new.create_destroy_audit(@current_user, 'Np2ntp', np2ntp.id)
    np2ntp.destroy
    flash[:notice] = 'Network Provider connection successfully destroyed'
    set_vars
    render :partial => "networkterminationpoints/network_providers"
  end
  
  def certify
    ntp_connection = Np2ntp.find(params[:id])
    connection_changes = get_changes(ntp_connection,{:user_id => @current_user.id, :certified_date => DateTime.now})
    ntp_connection.user_id = @current_user.id
    ntp_connection.certified_date = DateTime.now
    if ntp_connection.save
      Audittrail.new.create_update_audit(@current_user, "Np2ntp", ntp_connection.id,connection_changes)
      render :text => 'Certified.'
    else
      render :text => 'Error in submission. Connection no longer exists.'
    end    
  end
  
  def contest
    ntp_connection = Np2ntp.find_by_id(params[:id])
    render :text => 'Error in submission. Connection no longer exists.' and return if ntp_connection.nil?
    
    duplicate_ntp_connection = Np2ntp.find(:first,:conditions => ["id <> :id and networkprovider_id = :npId and networkterminationpoint_id = :ntpId and connectiontype_id = :typeId",
                                                  {:id => params[:id], :npId => ntp_connection.networkprovider_id, :ntpId => ntp_connection.networkterminationpoint_id, :typeId => params[:selected_connection_type_contest]}])
    if duplicate_ntp_connection and (ntp_connection.user.nil? or @current_user.is_np_editor?) then
      delete_with_audits('Np2ntp',ntp_connection.id)
      render :text => "Duplicate Connection Discarded." and return
    end
    unless ntp_connection.user_id.nil? or (@current_user.can_edit_networkprovider?(ntp_connection.networkprovider.id) and @current_user.associated_with_networkprovider?(ntp_connection.networkprovider.id))
      create_with_audits('ContestlistNp2ntp',{:np2ntp_id => ntp_connection.id, :user_id => @current_user.id, :connectiontype_id => params[:selected_connection_type_contest]})
      render :text => "Contested." and return
    end
    connection_changes = get_changes(ntp_connection,{:connectiontype_id => params[:selected_connection_type_contest], :user_id => @current_user.id})
    ntp_connection.connectiontype_id = params[:selected_connection_type_contest]
    ntp_connection.user_id = @current_user.id if @current_user.can_edit_networkprovider?(ntp_connection.networkprovider.id) and @current_user.associated_with_networkprovider?(ntp_connection.networkprovider.id)
    if ntp_connection.user.nil? && ntp_connection.save
      Audittrail.new.create_update_audit(@current_user, "Np2ntp", ntp_connection.id,connection_changes)
      render :text => "#{Connectiontype.find(params[:selected_connection_type_contest]).type_description}<script type=\"text/javascript\">$('certified_connection_#{ntp_connection.id}_a').innerHTML = 'Edit';</script>" and return
    end
    if (@current_user.can_edit_networkprovider?(ntp_connection.networkprovider_id) or @current_user.can_edit_networkterminationpoint?(ntp_connection.networkterminationpoint_id)) && ntp_connection.save
      Audittrail.new.create_update_audit(@current_user, "Np2ntp", ntp_connection.id,connection_changes)
      render :text => Connectiontype.find(params[:selected_connection_type_contest]).type_description and return
    end
  end
  
  def edit_step_0_submit
    if params[:np2ntp].nil? or params[:np2ntp][:networkprovider_id].blank? or params[:np2ntp][:networkterminationpoint_id].blank? then
      render :text => '' and return
    else
      render :partial => 'edit_step_1', :locals => {:networkprovider => Networkprovider.find_by_id(params[:np2ntp][:networkprovider_id]), 
                                                    :networkterminationpoint => Networkterminationpoint.find_by_id(params[:np2ntp][:networkterminationpoint_id]),
                                                    :np2ntp => Np2ntp.find_by_id(params[:np2ntp][:id]),
                                                    :edit_type => params[:edit_type]} and return
    end
  end

  def edit_step_1_submit
    if params[:np2ntp][:available] == 'Y' or params[:np2ntp][:available] == 'N' then
      render :partial => 'edit_step_2', :locals => {:networkprovider => Networkprovider.find_by_id(params[:np2ntp][:networkprovider_id]), 
                                                    :networkterminationpoint => Networkterminationpoint.find_by_id(params[:np2ntp][:networkterminationpoint_id]),
                                                    :np2ntp => Np2ntp.find_by_id(params[:np2ntp][:id]),
                                                    :edit_type => params[:edit_type],
                                                    :available => params[:np2ntp][:available]} and return
    else
      render :text => '' and return
    end
  end
  
  def edit_step_2_submit
    np = Networkprovider.find_by_id(params[:np2ntp][:networkprovider_id])
    if ['Y','N','U'].include?(params[:np2ntp][:multiple_access]) and \
      ['C','F','U'].include?(params[:np2ntp][:connection_type]) and \
      ((['O','L','U'].include?(params[:np2ntp][:owned]) and np.carrier_type == true) or np.extranet_type == true) then
      render :partial => 'edit_step_3', :locals => {:networkprovider => np, 
                                                    :networkterminationpoint => Networkterminationpoint.find_by_id(params[:np2ntp][:networkterminationpoint_id]),
                                                    :np2ntp => Np2ntp.find_by_id(params[:np2ntp][:id]),
                                                    :edit_type => params[:edit_type],
                                                    :available => params[:np2ntp][:available],
                                                    :connection_type => params[:np2ntp][:connection_type],
                                                    :multiple_access => params[:np2ntp][:multiple_access],
                                                    :owned => params[:np2ntp][:owned]} and return
    else
      render :text => "" and return
    end
  end
  
  def edit_submit
    params[:np2ntp][:connectiontype_id] = Connectiontype.find_by_type_description("******NEW******").id
    if params[:edit_type] == 'A' then
      @change_to_edit = true
      @np2ntp = Np2ntp.find(:first,:conditions => ["networkprovider_id = :npId and networkterminationpoint_id = :ntpId",
                                                    {:npId => params[:np2ntp][:networkprovider_id], :ntpId => params[:np2ntp][:networkterminationpoint_id]}])
      unless @np2ntp.nil?
        error = true
        flash[:notice] = "Duplicate Connection Already Exists"
      else
        @np2ntp = create_with_audits('Np2ntp',params[:np2ntp])
        @np2ntp.save!
      end
    else
      @np2ntp = Np2ntp.find_by_id(params[:np2ntp][:id])
      if params[:edit_type] == 'E' then
        @np2ntp = update_with_audits('Np2ntp',params[:np2ntp])
        @np2ntp.save!
      else #if params[:edit_type] == 'C' then
        params[:np2ntp][:np2ntp_id] = @np2ntp.id
        params[:np2ntp][:user_id] = @current_user.id
        params[:np2ntp].delete('id')
        params[:np2ntp].delete('networkterminationpoint_id')
        params[:np2ntp].delete('networkprovider_id')
        create_with_audits('ContestlistNp2ntp',params[:np2ntp])
      end
    end
    unless params[:connection_services].nil? or params[:edit_type] == 'C' or error
      new_services = (params[:connection_services].collect {|connection_service_description_id| connection_service_description_id.to_i}).delete_if {|srv| srv == 0}
      current_services = @np2ntp.connection_services.collect {|service| service.connection_service_description_id}
      (new_services - current_services).each do |service_id|
        new_service = create_with_audits('ConnectionService',{:np2ntp_id => @np2ntp.id, :connection_service_description_id => service_id})
        new_service.save!
      end
      (current_services - new_services).each do |service_id|
        service = ConnectionService.find(:first,:conditions => "np2ntp_id = #{@np2ntp.id} and connection_service_description_id = #{service_id}")
        delete_with_audits('ConnectionService',service.id) unless service.nil?
      end
      @np2ntp = Np2ntp.find_by_id(params[:np2ntp][:id])
    end
    if params[:edit_type] == 'A' then
      if session[:page]["provider"] then
        render :partial => 'np2ntps/np2ntps', :locals => {:networkprovider => Networkprovider.find_by_id(params[:np2ntp][:networkprovider_id])} and return
      else
        render :partial => 'np2ntps/np2ntps', :locals => {:networkterminationpoint => Networkterminationpoint.find_by_id(params[:np2ntp][:networkterminationpoint_id])} and return
      end
    elsif params[:edit_type] == 'E' then
      render :text => @np2ntp.details and return
    else #if params[:edit_type] == 'C' then
      render :text => 'Contested' and return
    end
  end
  
  private
  
  def set_vars
    np_connections = @networkterminationpoint.networkproviders.collect{|np| np.id}
    if np_connections.empty? or true then #Multiple connections of different types may exist for each np/ntp pair, so the list should include all nps
      @other_np_connections = Networkprovider.find(:all, :order => 'name').collect{|np| [np.name,np.id]}
    else
      @other_np_connections = Networkprovider.find(:all, :conditions => "id not in (#{np_connections.join(',')})", :order => 'name').collect{|np| [np.name,np.id]}
    end
    @connection_types = Connectiontype.find(:all, :order => 'name').collect {|t| ["#{t.name} - #{t.type_description}", t.id]}
    @change_to_edit = true
  end
end
