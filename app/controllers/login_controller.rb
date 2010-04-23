require "pdf/writer"
require "pdf/simpletable"

class LoginController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  layout "application", :except => [:login]
  before_filter :authorize, :except => [:login,:logout,:sample_pdf]

  def index
    redirect_to :controller => 'salesinfo', :action => 'home'
  end
  
  
  def sample_pdf
    pdf = PDF::Writer.new
    
    pdf.text "Sample PDF", :font_size => 20, :justification => :center
    
    pdf.text ' ', :font_size => 20, :justification => :center
    
    pdf_table = PDF::SimpleTable.new
    
    pdf_table.font_size = 10
    pdf_table.maximum_width = 500
    pdf_table.position = :left
    pdf_table.orientation = 15
    pdf_table.shade_heading_color = Color::RGB::Black
    pdf_table.shade_headings = true
    pdf_table.heading_color = Color::RGB::White
    pdf_table.heading_font_size = 11
    
    pdf_table.columns["h1"] = PDF::SimpleTable::Column.new("h1") {|col| 
      col.heading = "HEADING 1"; 
      col.link_name = "url" 
    }
    pdf_table.columns["h2"] = PDF::SimpleTable::Column.new("h2") {|col| col.heading = "HEADING 2"; }
    pdf_table.columns["url"] = PDF::SimpleTable::Column.new("url") {|col| col.heading = "url" }
    pdf_table.data = [{'h1' => "<a>This part should be a link</a> while this should not be", 'url' => "http://www.google.com",'h2' => "Regular text" },
                     {'h1' => "<a>There shouldn't be any '< a >' or '< / a >' tags here</a> or above", 'url' => "http://maps.google.com", 'h2' => "This should work if my changes were in place." },
                     {'h1' => "The next cell should be in ZapfDingbats font and colored green.", 'h2' => "font::ZapfDingbats::color::0,255,0::n abc" },
                     {'h1' => "The next cell should be in Courier font and colored red.", 'h2' => "font::Courier::color::255,0,0::Other Text"}]    
    pdf_table.column_order = ['h1','h2']
    pdf_table.render_on(pdf)
    
    send_data pdf.render, :filename => "sample_pdf.pdf",
              :type => "application/pdf"
  end

  def login
    session[:user_id] = nil
    @current_user = nil
    if request.post?
      if params[:commit] == 'Login' then
        user = User.authenticate(params[:email], params[:password])
        if user then
          user.set_last_activity(request.remote_ip,'L')
          session[:user_id] = user.id
          @current_user = user
          uri = "#{session[:original_uri]}"
          session[:original_uri] = nil
          if uri.blank? or uri == '/' or uri[0..5] == '/login'
            if user.networktermptowners.find_by_name('Equinix')
              redirect_to({:controller => 'salesinfo', :action => "home"}) and return
            end
            inquiries = Inquiry.find(:all,:conditions => "inquire_to_user_id = #{user.id} and sent_at is not null")
            unless inquiries.blank?
              need_to_respond = false
              inquiries.each do |inquiry|
                inquiry.inquiry_latency_times.each do |latency_time_inquiry|
                  need_to_respond = true if latency_time_inquiry.response_date.nil?
                end unless inquiry.inquiry_latency_times.blank?
                inquiry.inquiry_np2ntps.each do |np2ntp_inquiry|
                  need_to_respond = true if np2ntp_inquiry.response_date.nil?
                end unless inquiry.inquiry_np2ntps.blank?
              end
              redirect_to(:controller => 'inquiry', :action => "respond_to_inquiries") and return if need_to_respond
            end
            unless user.networktermptowners.empty? or user.networktermptowners.find_by_name('Equinix').nil?
              redirect_to({:controller => 'salesinfo', :action => "home" }) and return
            else
              if !user.networktermptowners.empty?
                redirect_to({:controller => 'manage', :action => "edit_ntp_owner" }) and return
              elsif !user.networkproviders.empty?
                redirect_to({:controller => 'networkproviders', :action => "edit" }) and return
              elsif !user.pointsofinterests.empty?
                redirect_to({:controller => 'pointsofinterests', :action => "edit" }) and return
              end
            end
          else
            redirect_to uri
          end
        else
          flash[:notice] = "Invalid Email or Password"
        end
      else
        if params[:email].blank?
          flash[:notice] = "Enter Email Address First" and return
        end
        user = User.find_by_email(params[:email])
        if user == nil or user.active != 'Y' then
          flash[:notice] = 'Unrecognized Email' and return
        end
        emailRegistration = Emailregistration.find(:first,:conditions => ["email_id = :email_id and used <> true and expiration_date >= :currentDate",
                                                                          {:email_id => hash_email(user.email), :currentDate => Date.today}])
        if emailRegistration != nil then
          flash[:notice] = "Email already sent" and return
        end
        emailRegistrationValues = {
          :user_id => user.id, 
          :email_id => hash_email(user.email), 
          :expiration_date => (Date.today + 1), 
          :reset => true, 
          :operating_user_id => user.id
        } 
        @email_registration = Emailregistration.new(emailRegistrationValues)
        @email_registration.save!
        session[:email_registration] = @email_registration
        UserMailer.deliver_reset_password_email(@email_registration)
        flash[:notice] = "Reset Email Sent"
      end
    end
  end
  
  
  def hash_user_id_and_email(user)
    string_to_hash = "#{user.id}inquiry#{user.email}"
    string_to_hash.unpack('U'*string_to_hash.length).join
  end


  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash[:notice] = "User #{@user.name} created"
      @user = User.new
    end
  end
  

  
  def delete_user
    if request.post?
      user = User.find(params[:id])
      begin
        user.destroy
        flash[:notice] = "User #{user.name} deleted"
      rescue Exception => e
        flash[:notice] = e.message
      end
    end
    redirect_to(:action => :list_users)
  end
  
  def list_users
    @all_users = User.find(:all)
  end
  
  def login_history
    @subnav = 'login_history'
    if params[:id].blank?
      @view_by = (params[:view_by].blank?)?('all'):(params[:view_by])
    else
      @view_by = "specific_user"
      @user = User.find_by_id(params[:id])
    end
  end
  
  def logout
    session[:original_uri] = nil
    session[:user_id] = nil
    @current_user = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
end
