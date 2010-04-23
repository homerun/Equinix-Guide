module ManageHelper
  
  def get_element_to_update(selector)
     @connections = { 'edit_service' => { 'region' => 'poi_selector', 'poi' => 'service_selector'},
                      'edit_poi' => {'region' => 'poi_selector' , 'poi' => 'edit_poi'},
                      'edit_ntp' => {'region' => 'country_selector', 'country' => 'ntp_selector', 'ntp_owner' => 'ntp_selector', 'networktermpttype_id' => 'ntp_selector'},
                      'edit_market' => {'region' => 'country_selector', 'country' => 'market_selector', 'market' => 'edit_market'},
                      'edit_latency_time' => {'networkprovider' => 'latency_time_selector', 'latency_time' => 'latency_time_selector'},
                      'view_ntps' => {'region_selector' => 'country_selector', 'country_selector' => 'ntp_selector', 'ntp_selector' => 'ntp_list'},
                      'edit_campus' => {'ntp_owner' => 'campus_selector', 'campus_selector' => 'edit_campus'},
                      'view_network_services' => {'region_selector' => 'country_selector', 'country_selector' => 'ntp_selector', 'ntp_selector' => 'view_network_services_pane'}}
    if session != nil and session[:page]!= nil and @connections[session[:page]] != nil then
      "#{@connections[session[:page]][selector]}"
    else 
      "#{session[:page]}"
    end
  end
  
  def get_latency_time(np2ntpA,np2ntpB)
    return nil if np2ntpA.networkprovider_id != np2ntpB.networkprovider_id
    latency_time = Latencytime.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and a_np2ntp_id = :np2ntpA and b_np2ntp_id = :np2ntpB", 
                                                          {:networkprovider_id => np2ntpA.networkprovider_id, 
                                                           :np2ntpA => [np2ntpA.id,np2ntpB.id].min(), 
                                                           :np2ntpB => [np2ntpA.id,np2ntpB.id].max() }])
  end
  
end
