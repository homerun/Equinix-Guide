class UserMailer < ActionMailer::Base

  def newuser(emailRegistration,operatingUser = nil,sent_at = Time.now)
    @subject    = 'Equinix New User Registration'
    @body       = {:first_name => emailRegistration.user.first_name, :last_name => emailRegistration.user.last_name, :confirmation_id => emailRegistration.email_id, :email_address => emailRegistration.user.email, :expiration_date => emailRegistration.expiration_date, :operating_user => operatingUser, :domain => BASE_URL}
    @recipients = "#{emailRegistration.user.email}"
    #@from       = "\"#{if emailRegistration.operating_user == nil then 'Equinix Representative' else emailRegistration.operating_user.print_name end}\" <#{if emailRegistration.operating_user == nil then 'donotreply@circuitclout.com' else emailRegistration.operating_user.email end}>"
    @from       = "\"#{((operatingUser.nil?)?('Equinix Representative'):(operatingUser.print_name))}\" <donotreply@circuitclout.com>"
    @content_type = "text/html"
    @sent_on    = sent_at
    #@cc         = "\"#{operatingUser.print_name}\" <#{operatingUser.email}>" unless operatingUser.nil? CC is a bad idea security-wise...
  end

  def reset_password_email(emailRegistration,operatingUser = nil,sent_at = Time.now)
    @subject    = 'Reset Forgotten Password'
    @body       = {:first_name => emailRegistration.user.first_name, :last_name => emailRegistration.user.last_name, :confirmation_id => emailRegistration.email_id, :expiration_date => emailRegistration.expiration_date, :operating_user => operatingUser, :domain => BASE_URL}
    @recipients = "#{emailRegistration.user.email}"
    @from       = "\"CircuitClout Admin\" <donotreply@circuitclout.com>"
    @content_type = "text/html"
    @sent_on    = sent_at
  end
  
  def shared_report(report,owner,user)
    @subject    = 'Report Shared with you on circuitclout.com'
    @body       = {:owner => owner, :report => report, :user => user, :domain => BASE_URL}
    @recipients = "#{user.email}"
    #@from       = "\"CircuitClout Admin\" <donotreply@circuitclout.com>"
    @from       = "\"#{owner.print_name}\" <donotreply@circuitclout.com>"
    @content_type = "text/html"
    @sent_on    = Time.now
    #@cc         = "\"#{owner.print_name}\" <#{owner.email}>"  CC is a bad idea security-wise...
  end
  
  def inquiry_to_np(user,send_to_name,send_to_email,inquiry,send_to_user)
    list_of_ntp_connections = Array.new
    list_of_unknown_ntps = Array.new
    inquiry.inquiry_np2ntps.each do |inquiry_np2ntp|
      existing_connections = inquiry_np2ntp.networkterminationpoint.connections_to(inquiry_np2ntp.networkprovider_id)
      if existing_connections.size > 0 then
        list_of_ntp_connections += existing_connections
      else
        list_of_unknown_ntps << inquiry_np2ntp.networkterminationpoint
      end
    end
    list_of_latency_times = Array.new
    list_of_inquiries_with_unknown_latency_times = Array.new
    inquiry.inquiry_latency_times.each do |latency_time_inquiry|
      current_latency_time = Latencytime.find(:first,:conditions => "a_np2ntp_id = #{[latency_time_inquiry.a_np2ntp_id,latency_time_inquiry.b_np2ntp_id].min} and b_np2ntp_id = #{[latency_time_inquiry.a_np2ntp_id,latency_time_inquiry.b_np2ntp_id].max} and networkprovider_id = #{latency_time_inquiry.networkprovider_id}")
      if current_latency_time.nil? then
        list_of_inquiries_with_unknown_latency_times << latency_time_inquiry
      else
        list_of_latency_times << current_latency_time
      end
    end
    @subject    = 'Connectivity At Network Termination Points'
    @body       = {:user => user, 
                   :list_of_ntp_connections => list_of_ntp_connections, 
                   :list_of_unknown_ntps => list_of_unknown_ntps, 
                   :list_of_latency_times => list_of_latency_times, 
                   :list_of_inquiries_with_unknown_latency_times => list_of_inquiries_with_unknown_latency_times,
                   :name => send_to_name, 
                   :send_to_user => send_to_user}
    @recipients = "#{send_to_email}"
    #@from       = "\"#{user.print_name}\" <#{user.email}>"
    @from       = "\"#{user.print_name}\" <donotreply@circuitclout.com>"
    @content_type = "text/html"
    @sent_on    = Time.now
    #@cc         = "\"#{user.print_name}\" <#{user.email}>" CC is a bad idea security-wise...
  end
end
