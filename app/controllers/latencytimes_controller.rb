class LatencytimesController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  before_filter :variables
  
  def update_networkprovider_selector
    @networkprovider_list = Array.new
    
    # if we're on the networkterminationpoints/edit page...
    networkterminationpoint = Networkterminationpoint.find_by_id(params[:networkterminationpoint])
    if networkterminationpoint then
      networkterminationpoint.networkproviders_connecting_to(nil).each {|np| @networkprovider_list << [np.name,np.id]}
      b_np2ntp = Np2ntp.find_by_id(params[:latencytime][:b_np2ntp_id])
      if params[:latencytime][:networkprovider_id].blank? then
        if b_np2ntp then
          @selected_networkprovider = b_np2ntp.networkprovider_id
        else
          @selected_networkprovider = ''
        end
      else
        @selected_networkprovider = params[:latencytime][:networkprovider_id].to_i
      end
      @networkprovider_list.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @networkprovider_list.insert(0,[' ',''])
    end
    
    # if we're on the networkproviders/edit page...
    networkprovider = Networkprovider.find_by_id(params[:networkprovider])
    if networkprovider then
      @networkprovider_list = [networkprovider]
      @selected_networkprovider = networkprovider.id
    end
    
    render :partial => 'networkprovider_list'
  end
  
  def update_b_np2ntp_id_selector
    @b_np2ntp_id_list = Array.new
    @selected_b_np2ntp_id = params[:latencytime][:b_np2ntp_id].to_i
    a_np2ntp = Np2ntp.find_by_id(params[:latencytime][:a_np2ntp_id])
    
    # if we're on the networkterminationpoints/edit page...
    networkterminationpoint = Networkterminationpoint.find_by_id(params[:networkterminationpoint])
    if networkterminationpoint then
      networkprovider = Networkprovider.find_by_id(params[:latencytime][:networkprovider_id])
      #@b_np2ntp_id_list << [["#{networkprovider.name}",'']]
      networkterminationpoint.networkterminationpoint_connections_through(networkprovider).each do |ntp_connection|
        @b_np2ntp_id_list << ["#{ntp_connection.networkterminationpoint.name} - #{ntp_connection.connectiontype.name}",ntp_connection.id] if ntp_connection.networkterminationpoint_id != networkterminationpoint.id
      end
      @b_np2ntp_id_list.sort! {|x,y| x[0].downcase <=> y[0].downcase}
      @b_np2ntp_id_list.insert(0,[' ',''])
    end
    
    # if we're on the networkproviders/edit page...
    networkprovider = Networkprovider.find_by_id(params[:networkprovider])
    if networkprovider then
      if a_np2ntp then
        @b_np2ntp_id_list = [' ','']
        a_np2ntp.networkprovider.ntp_connections.each do |ntp_connection|
          @b_np2ntp_id_list << [ntp_connection.networkterminationpoint.name,ntp_connection.id] if ntp_connection.networkterminationpoint_id != a_np2ntp.networkterminationpoint_id
        end
      else
        @b_np2ntp_id_list = ['Please Select a Network Termination Point (A) First','']
      end
    end
    render :partial => 'b_np2ntp_id_list'
  end
  
  def update_a_np2ntp_id_selector
    @a_np2ntp_id_list = Array.new
    @selected_a_np2ntp_id = params[:latencytime][:a_np2ntp_id].to_i
    
    # if we're on the networkterminationpoints/edit page...
    networkterminationpoint = Networkterminationpoint.find_by_id(params[:networkterminationpoint])
    if networkterminationpoint then
      networkprovider = Networkprovider.find_by_id(params[:latencytime][:networkprovider_id])
      if networkprovider then
        networkterminationpoint.np_connections.each do |np_connection|
          @a_np2ntp_id_list << ["#{np_connection.networkterminationpoint.name} - #{np_connection.connectiontype.name}",np_connection.id] if np_connection.networkterminationpoint_id == networkterminationpoint.id and np_connection.networkprovider_id == networkprovider.id
        end
      else
        @a_np2ntp_id_list << ['Please Select a Network Provider or Network Termination Point (B) First','']
      end
    end
    
    # if we're on the networkproviders/edit page...
    networkprovider = Networkprovider.find_by_id(params[:networkprovider])
    if networkprovider then
      @a_np2ntp_id_list << [' ','']
      networkproviders.ntp_connections.each do |ntp_connection|
        @a_np2ntp_id_list << [ntp_connection.networkterminationpoint.name,ntp_connection.id]
      end
    end
    render :partial => 'a_np2ntp_id_list'
  end
  
  def update_edit
    if !params[:latencytime][:a_np2ntp_id].blank? and !params[:latencytime][:b_np2ntp_id].blank? and params[:latencytime][:a_np2ntp_id].to_i > params[:latencytime][:b_np2ntp_id].to_i then
      temp = params[:latencytime][:a_np2ntp_id]
      params[:latencytime][:a_np2ntp_id] = params[:latencytime][:b_np2ntp_id]
      params[:latencytime][:b_np2ntp_id] = temp
    end
    if !params[:latencytime][:a_np2ntp_id].blank? and !params[:latencytime][:b_np2ntp_id].blank? and !params[:latencytime][:networkprovider_id].blank? then
      @latencytime = Latencytime.find(:first,:conditions => "a_np2ntp_id = #{params[:latencytime][:a_np2ntp_id]} and b_np2ntp_id = #{params[:latencytime][:b_np2ntp_id]} and networkprovider_id = #{params[:latencytime][:networkprovider_id]}")
      if @latencytime.nil? then
        @latencytime = Latencytime.new(params[:latencytime])
      end
    end
    render :partial => 'edit'
  end
  
  def certify
    new_values = {:id => params[:id], :user_id => @current_user.id}
    @latency_time = update_with_audits('Latencytime',new_values)
    ntp2ntp = {:a_np2ntp => @latency_time.np2ntpA, 
               :b_np2ntp => @latency_time.np2ntpB,
               :latency => @latency_time}
    render :partial => 'edit', :locals => {:ntp2ntp => ntp2ntp}
  end
  
  def update
    html_id = "#{[params[:latencytime][:a_np2ntp_id].to_i,params[:latencytime][:b_np2ntp_id].to_i].min}_#{[params[:latencytime][:a_np2ntp_id].to_i,params[:latencytime][:b_np2ntp_id].to_i].max}"
    if params["do_certify_#{html_id}"] == 'yes' then
      params[:latencytime][:user_id] = @current_user.id
    else
      params[:latencytime][:user_id] = nil
    end
    if params[:latencytime][:a_np2ntp_id].to_i > params[:latencytime][:b_np2ntp_id].to_i then
      params[:latencytime][:a_np2ntp_id],params[:latencytime][:b_np2ntp_id] = params[:latencytime][:b_np2ntp_id],params[:latencytime][:a_np2ntp_id]
    end
    if params[:latencytime][:id] == '' then
      @latency_time = create_with_audits('Latencytime',params[:latencytime])
    else
      @latency_time = update_with_audits('Latencytime',params[:latencytime])
    end
    @latency_time.save!
    ntp2ntp = {:a_np2ntp => Np2ntp.find_by_id(params[:latencytime][:a_np2ntp_id]), 
               :b_np2ntp => Np2ntp.find_by_id(params[:latencytime][:b_np2ntp_id]),
               :latency => @latency_time}
    render :partial => 'edit', :locals => {:ntp2ntp => ntp2ntp}
  end
  
  def edit_step1_submit
    @step2_list = Array.new
    @edit_page = params[:edit_page]
    @editable = params[:editable]
    if params[:edit_page] == 'Networkterminationpoint' then
      @networkterminationpoint = Networkterminationpoint.find_by_id(params[:networkterminationpoint_id])
      @list_type = params[:option][:view_by]
      if params[:option][:view_by] == 'networkterminationpoints' then
        b_ntps = @networkterminationpoint.networkterminationpoints_through(nil)
        b_ntps.each do |ntp|
          @step2_list << [ntp.name,ntp.id]
        end unless b_ntps.nil?
      else #if params[:view_by] == 'networkprovider' then
        @networkterminationpoint.networkproviders.each do |ntp|
          @step2_list << [ntp.name,ntp.id]
        end unless @networkterminationpoint.networkproviders.nil?
      end
    end
    @step2_list.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    render :partial => 'edit_step2'
  end
  
  def edit_step2_submit
    @step3_list = Array.new
    @edit_page = params[:edit_page]
    @editable = params[:editable]
    if params[:edit_page] == 'Networkterminationpoint' then
      @networkterminationpoint = Networkterminationpoint.find_by_id(params[:networkterminationpoint_id])
      if params[:list_type] == 'networkterminationpoints' then
        b_networkterminationpoint = Networkterminationpoint.find_by_id(params[:list_id])
        @b_ntp = b_networkterminationpoint
        networkproviders = @networkterminationpoint.networkproviders_connecting_to(params[:list_id].to_i)
        networkproviders.each do |networkprovider|
          @networkterminationpoint.connections_to(networkprovider.id).each do |a_np_connection|
            b_networkterminationpoint.connections_to(networkprovider.id).each do |b_np_connection|
              @step3_list << {:a_np2ntp => a_np_connection, 
                              :b_np2ntp => b_np_connection, 
                              :latency => Latencytime.find(:first,
                                                           :conditions => "a_np2ntp_id = #{[a_np_connection.id,b_np_connection.id].min} and b_np2ntp_id = #{[a_np_connection.id,b_np_connection.id].max} and networkprovider_id = #{a_np_connection.networkprovider_id}")}
            end
          end
        end
      else #if params[:view_by] == 'networkprovider' then
        @networkprovider = Networkprovider.find_by_id(params[:list_id]) 
        @networkterminationpoint.np_connections.each do |np_connection|
          if np_connection.networkprovider_id == params[:list_id].to_i then
            b_ntp_connections = @networkterminationpoint.networkterminationpoint_connections_through(params[:list_id].to_i)
            b_ntp_connections.each do |ntp_connection|
              @step3_list << {:a_np2ntp => np_connection, 
                              :b_np2ntp => ntp_connection, 
                              :latency => Latencytime.find(:first,
                                                           :conditions => "a_np2ntp_id = #{[np_connection.id,ntp_connection.id].min} and b_np2ntp_id = #{[np_connection.id,ntp_connection.id].max} and networkprovider_id = #{np_connection.networkprovider_id}")}
            end unless b_ntp_connections.nil?
          end
        end
      end
    else #if params[:edit_page] == 'networkprovider' then  
      @networkprovider = Networkprovider.find_by_id(params[:networkprovider_id]) 
      a_networkterminationpoint = Networkterminationpoint.find_by_id(params[:list_id])
      @networkterminationpoint = a_networkterminationpoint
      a_networkterminationpoint.np_connections.each do |np_connection|
        if np_connection.networkprovider_id == @networkprovider.id then
          b_ntp_connections = a_networkterminationpoint.networkterminationpoint_connections_through(@networkprovider.id)
          b_ntp_connections.each do |ntp_connection|
            @step3_list << {:a_np2ntp => np_connection, 
                            :b_np2ntp => ntp_connection, 
                            :latency => Latencytime.find(:first,
                                                         :conditions => "a_np2ntp_id = #{[np_connection.id,ntp_connection.id].min} and b_np2ntp_id = #{[np_connection.id,ntp_connection.id].max} and networkprovider_id = #{np_connection.networkprovider_id}")}
          end unless b_ntp_connections.nil?
        end
      end
    end
    @step3_list.sort! {|x,y| "#{x[:a_np2ntp].networkprovider.name} #{((x[:a_np2ntp].connectiontype.nil?)?(''):(x[:a_np2ntp].connectiontype.name))} #{x[:b_np2ntp].networkterminationpoint.name}" <=> "#{y[:a_np2ntp].networkprovider.name} #{((y[:a_np2ntp].connectiontype.nil?)?(''):(y[:a_np2ntp].connectiontype.name))} #{y[:b_np2ntp].networkterminationpoint.name}"}
    render :partial => 'edit_step3'
  end
   
  private
  def variables
    @subnav = "latency_times"
  end
  
end
