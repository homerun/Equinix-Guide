class Poi2ntpsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def create
    @change_to_edit = true
    @poi2ntp = Poi2ntp.find(:first,:conditions => ["pointsofinterest_id = :poiId and networkterminationpoint_id = :ntpId",
                                                  {:poiId => params[:poi2ntp_connections][:pointsofinterest_id], :ntpId => params[:poi2ntp_connections][:networkterminationpoint_id]}])
    if @poi2ntp.nil? then
      @poi2ntp = Poi2ntp.new(params[:poi2ntp_connections])
      if @poi2ntp.save
        Audittrail.new.create_new_audit(@current_user, "Poi2ntp", @poi2ntp.id)
      end
    else
      flash[:notice] = "Error: Duplicate Connection. Connection not added."
    end
    
    if params[:poi]
      @pointsofinterest = Pointsofinterest.find_by_id(params[:poi2ntp_connections][:pointsofinterest_id])
      set_poi_vars
      render :partial => "pointsofinterests/poi_networkterminationpoints"
    else
      @networkterminationpoint = Networkterminationpoint.find(params[:poi2ntp_connections][:networkterminationpoint_id])  
      set_ntp_vars
      render :partial => "networkterminationpoints/pois"
    end  
  end
  
  def destroy
    poi2ntp = Poi2ntp.find(params[:id])
    @networkterminationpoint = poi2ntp.networkterminationpoint
    @pointsofinterest = poi2ntp.poi
    Audittrail.new.create_destroy_audit(@current_user, 'Poi2ntp', poi2ntp.id)
    poi2ntp.destroy
    flash[:notice] = 'Point of Interest connection successfully destroyed'
    if params[:poi]
      set_poi_vars
      render :partial => "pointsofinterests/poi_networkterminationpoints"
    else
      set_ntp_vars
      render :partial => "networkterminationpoints/pois"
    end  
  end
  
  def contest
    ntp_connection = Poi2ntp.find_by_id(params[:id])
    render :text => 'Error in submission. Connection no longer exists.' and return if ntp_connection.nil?
    
    duplicate_ntp_connection = Poi2ntp.find(:first,:conditions => ["pointsofinterest_id = :poiId and networkterminationpoint_id = :ntpId and poiconnectiontype_id = :typeId and id <> :connection_id",
                                                  {:poiId => ntp_connection.pointsofinterest_id, :ntpId => ntp_connection.networkterminationpoint_id, :typeId => params[:contestPoiConnectionId], :connection_id => params[:id]}])
    if duplicate_ntp_connection and (ntp_connection.user.nil? or @current_user.is_poi_editor?) then
      delete_with_audits('Poi2ntp',ntp_connection.id)
      render :text => "Duplicate Connection Discarded." and return
    end
    unless ntp_connection.user_id.nil? or ntp_connection.user_id == @current_user.id
      create_with_audits('ContestlistPoi2ntp',{:poi2ntp_id => ntp_connection.id, :user_id => @current_user.id, :poiconnectiontype_id => params[:contestPoiConnectionId]})
      render :text => "Contested." and return
    end
    connection_changes = get_changes(ntp_connection,{:poiconnectiontype_id => params[:contestPoiConnectionId], :public => params[:poi2ntp_edit][:public], :user_id => @current_user.id})
    ntp_connection.poiconnectiontype_id = params[:contestPoiConnectionId]
    ntp_connection.public = params[:poi2ntp_edit][:public]
    ntp_connection.user_id = @current_user.id if @current_user.associated_with_pointsofinterest?(ntp_connection.pointsofinterest_id)
    if ntp_connection.user.nil? && ntp_connection.save
      Audittrail.new.create_update_audit(@current_user, "Poi2ntp", ntp_connection.id,connection_changes)
      if @current_user.associated_with_pointsofinterest?(ntp_connection.pointsofinterest_id)
        render :text => "#{Poiconnectiontype.find(params[:contestPoiConnectionId]).description}<script type=\"text/javascript\">$('certified_poi_connection_#{ntp_connection.id}').innerHTML = 'Yes'; $('connection_public_#{ntp_connection.id}').innerHTML = '#{ ((ntp_connection.public)?('Yes'):('No')) }';</script>" and return
      else
        render :text => "#{Poiconnectiontype.find(params[:contestPoiConnectionId]).description}<script type=\"text/javascript\">$('certified_poi_connection_#{ntp_connection.id}_a').innerHTML = 'Edit'; $('connection_public_#{ntp_connection.id}').innerHTML = '#{ ((ntp_connection.public)?('Yes'):('No')) }';</script>" and return
      end
    end
    if ntp_connection.save
      Audittrail.new.create_update_audit(@current_user, "Poi2ntp", ntp_connection.id,connection_changes)
      render :text => "#{Poiconnectiontype.find(params[:contestPoiConnectionId]).description}<script type=\"text/javascript\"> $('certified_poi_connection_#{ntp_connection.id}').innerHTML = 'Yes'; $('connection_public_#{ntp_connection.id}').innerHTML = '#{ ((ntp_connection.public)?('Yes'):('No')) }';</script>" and return
    end
    render :text => "Failed."
  end
  
  def certify
    ntp_connection = Poi2ntp.find(params[:id])
    connection_changes = get_changes(ntp_connection,{:user_id => @current_user.id, :certified_date => DateTime.now})
    ntp_connection.user_id = @current_user.id
    ntp_connection.certified_date = DateTime.now
    if ntp_connection.save
      Audittrail.new.create_update_audit(@current_user, "Poi2ntp", ntp_connection.id,connection_changes)
      render :text => 'Certified.'
    else
      render :text => 'Error in submission. Connection no longer exists.'
    end    
  end

  private  
  
  def set_ntp_vars
    unless @networkterminationpoint.blank?
      poi_connections = @networkterminationpoint.pois.collect{|poi| poi.id}
      if poi_connections.empty?
        @other_poi_connections = Pointsofinterest.find(:all, :order => 'name').collect {|poi| [poi.name,poi.id]}  
      else
        @other_poi_connections = Pointsofinterest.find(:all, :conditions => "id not in (#{poi_connections.join(',')})", :order => 'name').collect{|poi| [poi.name,poi.id]}  
      end
    end
    @poi_connection_types = Poiconnectiontype.find(:all, :order => 'name').collect { |t| ["#{t.name} - #{t.description}", t.id] }
    @change_to_edit = true
  end  
  
  def set_poi_vars
    ntp_connections = @pointsofinterest.networkterminationpoints.collect {|ntp| ntp.id} 
    if ntp_connections.empty?
      @other_ntp_connections = Networkterminationpoint.find(:all, :order => 'name').collect {|ntp| [ntp.name,ntp.id]}
    else  
      @other_ntp_connections = Networkterminationpoint.find(:all, :conditions => "id not in (#{ntp_connections.join(',')})", :order => 'name').collect {|ntp| [ntp.name,ntp.id]}   
    end
    @poi_connection_types = Poiconnectiontype.find(:all, :order => 'name').collect { |type| ["#{type.name} - #{type.description}", type.id] }
  end
end
