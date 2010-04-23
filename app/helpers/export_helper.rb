module ExportHelper
  
  
  def print_full_addr_excel(ntp)
    returnString = ''
    returnString += ntp.street_address
    returnString += "&#10;Floor: #{ntp.floor}" if ntp.floor != nil and !ntp.floor.blank?
    returnString += "&#10;Suite: #{ntp.suite}" if ntp.suite != nil and !ntp.suite.blank?
    returnString += "&#10;#{ntp.city}" if ntp.city != nil and !ntp.city.blank?
    returnString += ", #{ntp.state_or_province}" if ntp.state_or_province != nil and !ntp.state_or_province.blank?
    returnString += " #{ntp.zip_code}" if ntp.zip_code != nil and !ntp.zip_code.blank?
    returnString += "&#10;#{ntp.parentcountry.name}" if ntp.parentcountry != nil and !ntp.parentcountry.blank?
    returnString
  end
  
  
  def print_latency_time_excel(np,datacenter,poi_ntp)
    np2ntpDatacenter = Np2ntp.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and networkterminationpoint_id = :networkterminationpoint_id", {:networkprovider_id => np.id, :networkterminationpoint_id => datacenter.id}])
    np2ntpPoi = Np2ntp.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and networkterminationpoint_id = :networkterminationpoint_id", {:networkprovider_id => np.id, :networkterminationpoint_id => poi_ntp.id}])
    return "NO" if np2ntpDatacenter == nil or np2ntpPoi == nil
    latency_time = Latencytime.find(:first,:conditions => ["networkprovider_id = :networkprovider_id and a_np2ntp_id = :np2ntpA and b_np2ntp_id = :np2ntpB", 
                                                          {:networkprovider_id => np.id, 
                                                           :np2ntpA => [np2ntpDatacenter.id,np2ntpPoi.id].min(), 
                                                           :np2ntpB => [np2ntpDatacenter.id,np2ntpPoi.id].max() }])
    return "<B>YES</B>&#10;#{np2ntpPoi.details}" if latency_time == nil
    "<B>YES</B>&#10;#{np2ntpPoi.details}310;#{latency_time.latencyTime} ms"
  end
  
  
  def get_distance_with_theoretical_latency_excel(ntpSelf, ntpOther)
    if ntpOther.lat == nil or ntpOther.lon == nil or ntpSelf.lat == nil or ntpSelf.lon == nil or ntpSelf == ntpOther then
      return ''
    end
    other_lat = ntpOther.lat.to_f
    other_lon = ntpOther.lon.to_f
    self_lat = ntpSelf.lat.to_f
    self_lon = ntpSelf.lon.to_f
    to_rads = Math::PI / 180.0
    begin
      d = 6378.137*Math.acos(Math.cos((90.0-self_lat)*to_rads)*Math.cos((90.0-other_lat)*to_rads)+Math.sin((90.0-self_lat)*to_rads)*Math.sin((90.0-other_lat)*to_rads)*Math.cos((self_lon-other_lon)*to_rads))
    rescue
      return ''
    end
    "#{((d * 100).round.to_f / 100)} km&#10;#{(d * 62.1371192).round.to_f / 100} miles&#10;#{(d/0.0299792458).round.to_f / 10000} ms"
  end
  
  
  
  def print_np2ntp_connection_types_excel(np,dc,separator)
    connection = Np2ntp.find(:first, :conditions => ["networkprovider_id = :networkprovider_id and networkterminationpoint_id = :networkterminationpoint_id", {:networkprovider_id => np.id, :networkterminationpoint_id => dc.id}])
    return ' ' if connection.connectiontype == nil
    connection.details
    #connection.type_connection.types.collect { |type| type.type_description }).join(separator)
  end
end
