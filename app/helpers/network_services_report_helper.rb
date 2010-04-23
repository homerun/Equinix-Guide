module NetworkServicesReportHelper
  
  def print_network_service_connection_to_ntp(np2ntp_list, ntp)
    np2ntp_list.each do |np2ntp|
      if np2ntp.networkterminationpoint == ntp and !np2ntp.connectiontype.not_a_connection then
        if ['A','C','D','G'].include?(np2ntp.connectiontype.name) then
          return 'O'
        else
          return 'X'
        end
      end
    end
    return ' '
  end
  
end
