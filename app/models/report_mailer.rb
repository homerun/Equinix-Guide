require 'net/imap'
require 'net/http'
require 'pdf/writer'
require 'pdf/simpletable'
class ReportMailer < ActionMailer::Base
  
  def self.check_email
    imap = Net::IMAP.new(DD_SERVER,DD_PORT,true)
    imap.login(DD_USERNAME, DD_PASSWORD)
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      self.receive(imap.fetch(message_id, "RFC822")[0].attr["RFC822"])
      imap.store(message_id, "+FLAGS", [:Deleted])
    end
    imap.logout()
    imap.disconnect()
  end
  
  def receive(email)
    puts "#{email.from.first}: \t#{email.subject}"
    if %w(@equinix.com @ap.equinix.com @equinix.co.uk).any? {|str| email.from.first.include? str}
      puts 'Email Permitted'
      report_name = email.subject.gsub(/\s*[m|M]etro [r|R]eport\s*/, "")
      puts "Checking for Market titled '#{report_name}'"
      market = Market.find_by_market_name(report_name)
      if market
        puts "Market Found... Getting PDF"
        pdf = Report.get_equinix_metro_report_pdf_object(market)
        pdf_name = RAILS_ROOT + "/public/Equinix-Metro-Report-#{market.market_name}-#{Time.now.to_i}.pdf"
        puts "Saving PDF here: #{pdf_name}"
        pdf.save_as(pdf_name)
        puts "PDF Saved"
        
        recipients = [email.from.first]
        if email.cc
          email.cc.each do |cc|
            recipients << cc
          end
        end
        recipients.each do |send_to|
          puts "Sending report to #{send_to}"
          ReportMailer.deliver_market_report(send_to, email, market.market_name, pdf_name)
          puts "Report Sent"
        end

        File.delete(pdf_name)
        puts "PDF File Deleted"
      else
        puts "Market Not Found"
        markets = Market.find(:all).collect{|m| m.market_name}
        market_list = markets.join(', ')
        ReportMailer.deliver_invalid_report(email, market_list)
        puts "Delivered invalid report email"
      end
    else
      puts 'Email NOT Permitted'
    end
  end
  
  def market_report(send_to, email, market_name, pdf_name)
    @subject    = "Equinix #{market_name} Metro Report"
    @body = {:market => market_name, :requestor => email.from.first}
    
    attachment :content_type => "application/pdf",
               :content_disposition => 'attachment',
               :transfer_encoding => 'base64',
               :body => File.read(pdf_name),
               :filename => "Equinix-Metro-Report-#{market_name}.pdf"	 		 

		@recipients = send_to
    @from       = "\"Equinix GUIDE Reports\" <donotreply@circuitclout.com>"
    @sent_on    = Time.now
  end
  
  def invalid_report(email, market_list)
    @subject    = "ATTN Failed Request: #{email.subject}"
    @body       = {:email => email, :market_list => market_list, :domain => BASE_URL}
    @recipients = email.from.first
    @from       = "\"Equinix GUIDE Reports\" <donotreply@circuitclout.com>"
    @content_type = "text/plain"
    @sent_on    = Time.now
  end
  
end