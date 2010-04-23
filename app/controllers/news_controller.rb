class NewsController < ApplicationController
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  def check_url
    stripped_url = params[:url].chomp('http://').chomp('www.')
    existing_news_item = Newsitem.find(:first,:conditions => ["url like :url", {:url => "%#{stripped_url}%"}])
    unless existing_news_item.nil?
      render :text => "<script type=\"text/javascript\">alert('A news article with a similar url was found. It is titled \"#{existing_news_item.title}\" and was submitted on #{existing_news_item.created_at.strftime('%m/%d/%Y')} by #{existing_news_item.user.print_name}');</script>" and return
    end
    begin
      render :text => "Please put in the URL first.<script type=\"text/javascript\">setTimeout(\"$('news_action').innerHTML = '';\",2000); </script>" and return if params[:url] == nil or params[:url].blank?
      params[:url].strip!
      params[:url] = 'http://' + params[:url] if params[:url][0..6] != 'http://'
      response = Net::HTTP.get URI.parse(params[:url])
      rTitle = Regexp.new('<title>[^<]*</title>',true)
      @title = response.scan(rTitle)
      if @title != nil and @title..instance_of?(Array) then
        @title = "#{@title[0]}"
      end
    rescue => detail
      render :text => "Page Not Found<script type=\"text/javascript\">setTimeout(\"$('news_action').innerHTML = '';\",2000); </script>" and return
    end
    if @title != nil then
      @title.sub!(Regexp.new('<title>',true),'')
      @title.sub!(Regexp.new('</title>',true),'')
      @title.strip! 
    end
    render :text => "<script type=\"text/javascript\">$('newsitem_title').value = '#{ @title }'; </script>"
  end
  
  def submit_news
    @subnav = "submit_news"
    session[:page] = 'submit_news'
    session[:original_uri] = request.request_uri
    if request.post? then
      if params[:newsitem][:title] == nil or params[:newsitem][:title].blank? then
        flash[:notice] = "Title cannot be blank."
        @the_url = params[:newsitem][:url]
      elsif params[:newsitem][:url] == nil or params[:newsitem][:url].blank? then
        flash[:notice] = "URL cannot be blank."
        @title = params[:newsitem][:title]
      else
        params[:newsitem][:url] = 'http://' + params[:newsitem][:url] if params[:newsitem][:url][0..6] != 'http://'
        params[:newsitem][:tags] = (params[:newsitem][:tags].split(',').delete_if {|x| x.blank? }).join(',') if params[:newsitem][:tags] != nil
        @newsitem = create_with_audits('Newsitem',params[:newsitem])
        @newsitem.save!
        poiTags = params['poiTags'].split(',') if params['poiTags'] != nil
        poiTags.each do |tagId|
          create_with_audits('News2poi',{:newsitem_id => @newsitem.id, :pointsofinterest_id => tagId}) if !tagId.blank?
        end if poiTags != nil
        npTags = params['npTags'].split(',') if params['npTags'] != nil
        npTags.each do |tagId|
          create_with_audits('News2np',{:newsitem_id => @newsitem.id, :networkprovider_id => tagId}) if !tagId.blank?
        end if npTags != nil
        ntpOwnerTags = params['ntpOwnerTags'].split(',') if params['ntpOwnerTags'] != nil
        ntpOwnerTags.each do |tagId|
          create_with_audits('News2ntpowner',{:newsitem_id => @newsitem.id, :networktermptowner_id => tagId}) if !tagId.blank?
        end if ntpOwnerTags != nil
        regionTags = params['regionTags'].split(',') if params['regionTags'] != nil
        regionTags.each do |tagId|
          create_with_audits('News2region',{:newsitem_id => @newsitem.id, :equinixregion_id => tagId}) if !tagId.blank?
        end if regionTags != nil
        marketTags = params['marketTags'].split(',') if params['marketTags'] != nil
        marketTags.each do |tagId|
          create_with_audits('News2market',{:newsitem_id => @newsitem.id, :market_id => tagId}) if !tagId.blank?
        end if marketTags != nil
        otherTags = params[:newsitem][:tags].split(',') if params[:newsitem][:tags] != nil
        otherTags.each do |tag|
          tag = tag.strip
          if !tag.blank? then
            tag_obj = Othertag.find_by_tag(tag) 
            if tag_obj == nil then
              tag_obj = create_with_audits('Othertag',{:tag => tag})
              tag_obj.save!
            end
            tag_obj_id = OthertagNewsitem.find(:first,:conditions => ["othertag_id = :tag_id and newsitem_id = :news_id", {:tag_id => tag_obj.id, :news_id => @newsitem.id}])
            unless tag_obj_id
              tag_obj_id = create_with_audits('OthertagNewsitem',{:othertag_id => tag_obj.id, :newsitem_id => @newsitem.id})
              tag_obj_id.save!
            end
          else
              #flash[:notice] += "-nope, "
          end
        end if otherTags != nil
        fieldValues = {:newsitem_id => @newsitem.id, :user_id => session[:user_id], :rating => true}
        create_with_audits('Newsrating',fieldValues)
        #flash[:newsitem] = "News submitted, thank you!"
        redirect_to :action => 'view_news' 
      end
    end
    @user_id = session[:user_id]
    @list_of_ntpOwners = (Networktermptowner.find(:all).collect {|x| ["#{x.name}","#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
    @list_of_pois = (Pointsofinterest.find(:all).collect {|x| ["#{x.name}","#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
    @list_of_nps = (Networkprovider.find(:all).collect {|x| ["#{x.name}","#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
    @list_of_markets = (Market.find(:all).collect {|x| ["#{x.market_name}","#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
    @list_of_regions = (Equinixregion.find(:all).collect {|x| ["#{x.region_name}","#{x.id}"]}).sort {|x,y| x[0].downcase <=> y[0].downcase}
  end
  
  def sort_news
    @list_of_news = Newsitem.find(params[:ids].split(','))
    @size_message = "#{@list_of_news.size}"
    @message = "#{params[:ids]}"
    if params[:sort] == "Hottest" then
      @list_of_news.sort! {|x,y| y.point_value_hottest <=> x.point_value_hottest}
    elsif params[:sort] == "Upcoming" then
      @list_of_news.sort! {|x,y| y.point_value_upcoming <=> x.point_value_upcoming}
    elsif params[:sort] == "Most Popular" then
      @list_of_news.sort! {|x,y| (y.net_rating == x.net_rating ? (y.created_at == nil ? Time.now : y.created_at) : y.net_rating) <=> (y.net_rating == x.net_rating ? (x.created_at == nil ? Time.now : x.created_at) : x.net_rating)}
    elsif params[:sort] == "Date of Article" then
      @list_of_news.sort! {|x,y| (y.article_date == nil ? Date.today : y.article_date) <=> (x.article_date == nil ? Date.today : x.article_date)}
    else # if params[:sort] == "Date Submitted" then
      @list_of_news.sort! {|x,y| (y.created_at == nil ? Time.now : y.created_at) <=> (x.created_at == nil ? Time.now : x.created_at)}
    end
    @sort_order = params[:sort]
    @user_id = session[:user_id]
    @start_range = params[:start_range] if !params[:start_range].blank?
    @title = params[:title] if !params[:title].blank?
    render :partial => '/shared/news_pane'
  end
  
  def view_news
    @subnav = "view_news"
    session[:page] = 'view_news'
    session[:original_uri] = request.request_uri
    @list_of_news = Newsitem.find(:all).sort {|x,y| y.point_value_hottest <=> x.point_value_hottest}
    @sort_order = "Hottest"
    @user_id = session[:user_id]
  end
  
  def rate_news
    fieldValues = {:newsitem_id => params[:id], :user_id => session[:user_id], :rating => (if params[:rating] == "Y" then true else false end)}
    create_with_audits('Newsrating',fieldValues)
    if params[:rating] == "Y" then
      plus_img = "<img class=\"item_img\" src=\"/images/plus_selected.jpg\" width=\"20\" />"
      minus_img = "<img class=\"item_img\" src=\"/images/minus_default.jpg\" width=\"20\" />"
    else
      plus_img = "<img class=\"item_img\" src=\"/images/plus_default.jpg\" width=\"20\" />"
      minus_img = "<img class=\"item_img\" src=\"/images/minus_selected.jpg\" width=\"20\" />"
    end
    news_item = Newsitem.find_by_id(params[:id])
    script = "<script type=\"text/javascript\">$('news_#{params[:id]}_point_value').innerHTML = '<span class=\"positive_rating\">#{news_item.net_rating}</span>';</script>"
    render :text => "#{plus_img}<br/><br/>#{minus_img}#{script}"
  end
  
  def write_to_file
    str = ""
    radius = 0.1
    x = 0
    y = 0
    max = 100
    (0..max).each do |point|
      str += "#{x+radius*Math.cos(point*((Math::PI/2)/max))},#{y+radius*Math.sin(point*((Math::PI/2)/max))},0<br/>"
      #str += "#{(point+0.0)/max} : #{Math.cos(((point+0.0)/max)*(Math::PI/2))} , #{Math.sin(((point+0.0)/max)*(Math::PI/2))},0<br/>"
    end
    render :text => "DONE:<br/>#{str}"
  end
  
  def notification_rules
    
  end
  
end
