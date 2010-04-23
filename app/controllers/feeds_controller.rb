class FeedsController < ApplicationController  
  include ExceptionNotifiable
  local_addresses.clear if EXCEPTIONS_ON
  
  before_filter :authorize, :except => [:my_feed]
  
  @@object_to_edit_page = {'Networkterminationpoint' => {:page => 'networkterminationpoints/edit', :table => 'Networkterminationpoint', :field => 'id'}, 
                           'Networkprovider' => {:page => 'networkproviders/edit', :table => 'Networkprovider', :field => 'id'},
                           'Pointsofinterest' => {:page => 'pointsofinterests/edit', :table => 'Pointsofinterest', :field => 'id'},
                           'Networktermptowner' => {:page => 'manage/edit_ntp_owner', :table => 'Networktermptowner', :field => 'id'},
                           'Equinixregion' => {:page => 'manage/edit_region', :table => 'Equinixregion', :field => 'id'},
                           'Market' => {:page => 'manage/edit_market', :table => 'Market', :field => 'id'},
                           'Datacenterdetail' => {:page => 'networkterminationpoints/edit', :table => 'Datacenterdetail', :field => 'networkterminationpoint_id'},
                           'Poi2ntp' => {:page => 'pointsofinterests/edit', :table => 'Poi2ntp', :field => 'pointsofinterest_id'},
                           'Np2ntp' => {:page => 'networkproviders/edit', :table => 'Np2ntp', :field => 'networkprovider_id'},
                           'Campus' => {:page => 'campus/edit', :table => 'Campus', :field => 'id'},
                           'CampusAccessType' => {:page => 'campus/edit', :table => 'Campus', :field => 'campus_id'},
                           'CampusNtp2ntp' => {:page => 'campus/edit', :table => 'Campus', :field => 'campus_id'},
                           'Poipreferrednp' => {:page => 'pointsofinterests/edit', :table => 'Poipreferrednp', :field => 'pointsofinterest_id'}}
  
  def my_feed
    headers['Content-Type'] = "application/rss+xml"
    headers['Cache-Control'] = ''
    if params[:id] != nil then
      user_id = ((((params[:id].to_i - 41)/67) - 31)/537 - 33)
      user = User.find_by_id(user_id)
      if user != nil then
        logged_in_user = session[:user_id]
        session[:user_id] = user.id
        @current_user = user
        notificationRules = user.notification_rules
        if notificationRules == nil or notificationRules.size == 0 then
          @feed_items = [{:title => "No items", :date => Time.now, :descr => "Please set up your notification rules before you use this feed.", :guid => 'noFeed'}]
        else
          conditionTree = buildConditionTree(notificationRules)
          @feed_items = get_feed_items_from_tree(conditionTree,!conditionTree[:has_children])
          @feed_items.sort! {|x,y| (y[:date] == nil ? Time.now : y[:date]) <=> (x[:date] == nil ? Time.now : x[:date])}
        end
        session[:user_id] = logged_in_user
        @current_user = logged_in_user
      else
        @feed_items = [{:title => "Sorry", :date => Time.now, :descr => "This feed is available to equinix users only.", :guid => 'badFeed'}]
      end
    else
      @feed_items = [{:title => "Sorry", :date => Time.now, :descr => "This feed is  available to equinix users only.", :guid => 'badFeed'}]
    end
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
  
  def new_notification_rule
    @object_name_options = Array.new
    ['Networkterminationpoint','Networkprovider','Pointsofinterest','Equinixregion','Networktermptowner','Market','Newsitem'].each do |object_name|
      @object_name_options << [table_label(object_name).plural,object_name]
    end
    @object_name_options.sort! {|x,y| x[0].downcase <=> y[0].downcase}
    @object_name_options.insert(0,['All','ALL'])
    render :partial => 'new_notification_rule'
  end
  
  def new_notification_rule_step_one
    table_name = params[:notificationrule][:object_name]
    @scope = {:news => (params[:news_notifications]=='on'), :additions => (params[:additions_notifications]=='on'), :updates => (params[:updates_notifications]=='on')}
    @object_name_label = table_label(table_name)
    if table_name == 'Networkterminationpoint' then
      @field_name_options = [["what I select",'id'],['Name','name'],['Country','country_id'],["Type of #{@object_name_label.label}",'networktermpttype_id']]
    elsif table_name == 'Networkprovider' then
      @field_name_options = [["what I select",'id'],['Name','name'],["#{@object_name_label.label} types",'networkProviderTypes']]
    elsif table_name == 'Pointsofinterest' then
      @field_name_options = [["what I select",'id'],['Name','name'],['Region','unsubregion_id'],["Type of #{@object_name_label.label}",'poitype_id'],['Asset Classes','assetClasses']]
    elsif table_name == 'Equinixregion' then
      @field_name_options = [["what I select",'id']]
    elsif table_name == 'Networktermptowner' then
      @field_name_options = [["what I select",'id']]
    elsif table_name == 'Market' then
      @field_name_options = [["what I select",'id'],['Country','country_id']]
    elsif table_name == 'Newsitem' then
      @scope[:news] = true
      @field_name_options = [['Title','title'],['Description','descr'],['Other Tags','tags']]
    else # table_name == 'ALL' then
      @field_name_options = [['Title/Name','search_fields']]
    end
    if @scope[:additions] and !@scope[:news] and !@scope[:updates] then
      user = User.find_by_id(session[:user_id])
      rules = user.notification_rules
      if rules == nil or rules.size == 0 then
        @seq_num = 1
      else
        @seq_num = rules[rules.size-1].seq_num + 1
      end
    end
    render :partial => 'new_notification_rule_step_two'
  end
  
  def new_notification_rule_step_two
    table_name = params[:notificationrule][:object_name]
    @scope = {:news => (params[:notificationrule][:get_news]==true), :additions => (params[:notificationrule][:get_additions]==true), :updates => (params[:notificationrule][:get_updates]==true)}
    @object_name_label = table_label(table_name)
    if params[:notificationrule][:allObjects] == 'no' then
      @field_name = params[:notificationrule][:field_name]
      @field_name_label = field_label(table_name,@field_name)
      if @field_name == 'id' then
        objs = eval("#{table_name}.find(:all)")
        @list_of_ids = objs.collect {|x| [eval("x.#{@object_name_label.look_up_field}"),x.id]}
        @comparison_operator = 'in'
      elsif ['name','name','title','descr','tags'].include?(@field_name) then
        @comparison_operator = 'like'
      elsif @field_name == 'country_id' then
        @list_of_ids = Country.find(:all).collect {|x| [x.name,x.id]}
        @comparison_operator = 'in'
      elsif @field_name == 'networktermpttype_id' then
        @list_of_ids = Networktermpttype.find(:all).collect {|x| [x.name,x.id]}
        @comparison_operator = 'in' 
      elsif @field_name == 'poitype_id' then
        @list_of_ids = Poitype.find(:all).collect {|x| [x.name,x.id]}
        @comparison_operator = 'in' 
      elsif @field_name == 'networkProviderTypes' then
        @list_of_ids = [['Carrier','carrier_type'],['Extranet','extranet_type'],['ISP','isp_type'],['Optimized IP Routing','routing_type']]
        @comparison_operator = 'checkboxes'
      elsif @field_name == 'unsubregion_id' then
        @list_of_ids = Unsubregion.find(:all).collect {|x| [x.name,x.id]}
        @comparison_operator = 'in' 
      elsif @field_name == 'assetClasses' then
        @list_of_ids = [['Equity Classes','equities_class'],['Derivatives','futures_class'],['Fixed Income','fixed_income_class'],['Foreign Exchange','foreign_exchange_class']]
        @comparison_operator = 'checkboxes'
      else # if @field_name == 'ALL' then
        @comparison_operator = 'like'
      end
      @list_of_ids.sort! {|x,y| x[0].downcase <=> y[0].downcase} if @list_of_ids != nil
    else
      @field_name = 'ALL'
    end
    user = User.find_by_id(session[:user_id])
    rules = user.notification_rules
    if rules == nil or rules.size == 0 then
      @seq_num = 1
    else
      @seq_num = rules[rules.size-1].seq_num + 1
    end
    render :partial => 'new_notification_rule_step_three'
  end
  
  def add_new_notification_rule
    params[:notificationrule][:comparison_value] = "%#{params[:notificationrule][:comparison_value]}%" if params[:notificationrule][:comparison_operator] == 'like'
    params[:notificationrule][:comparison_value] = "(#{params[:comparison_value].join('').chomp(',')})" if params[:notificationrule][:comparison_operator] == 'in' 
    notificationrule = create_with_audits('Notificationrule',params[:notificationrule])
    notificationrule.save!
    redirect_to :action => :notification_rules
  end
  
  def notification_rules
    @subnav = "notifications"
    session[:original_uri] = request.request_uri
    session[:page] = 'notification_rules'
    @notification_rules = @current_user.notification_rules
    @feed_url = "/feeds/my_feed/#{(((@current_user.id + 33)*537 + 31)*67 + 41)}"
  end
  
  def remove_notification_rule
    delete_with_audits('Notificationrule',params[:deleteId])
    user = User.find_by_id(session[:user_id])
    @notification_rules = user.notification_rules
    render :partial => 'current_notification_rules'
  end
  
  private
  
  def buildConditionTree(rules)
    current = {:has_children => false, :rule => rules[0]}
    session[:rule_index] = 1
    if session[:rule_index] < rules.size then 
      return buildParent(current,rules)
    else
      return current
    end
  end
  
  def buildRHS(rules)
    rule_node = {:has_children => false, :rule => rules[session[:rule_index]]}
    session[:rule_index] += 1
    if session[:rule_index] >= rules.size or rule_node[:rule].r_paren > 0 then
      return rule_node
    else
      and_or = rules[session[:rule_index]].and_or
      return {:has_children => true, :lhs => rule_node, :rhs => buildRHS(rules), :and_or => and_or}
    end
  end
  
  def buildParent(lhs,rules)
    and_or = rules[session[:rule_index]].and_or
    current = {:has_children => true, :lhs => lhs, :rhs => buildRHS(rules), :and_or => and_or}
    if session[:rule_index] < rules.size then
      return buildParent(current,rules)
    else
      return current
    end
  end
  
  def news_items_to_feed_items(rule)
    if rule.field_name == 'ALL'
      news_items = Newsitem.find(:all)
    elsif rule.field_name == 'search_fields'
      news_items = Newsitem.find(:all, :conditions => ["title #{rule.comparison_operator} :value or descr #{rule.comparison_operator} :value",{:value => rule.comparison_value}])
    else
      if rule.comparison_operator == 'like' then
        news_items = Newsitem.find(:all, :conditions => ["#{rule.field_name} #{rule.comparison_operator} :value",{:value => rule.comparison_value}])
      else
        news_items = Newsitem.find(:all, :conditions => ["#{rule.field_name} #{rule.comparison_operator} #{rule.comparison_value}"])
      end
    end
    feed_items = Array.new
    effDtTime = Time.parse(rule.start_date.strftime('%m/%d/%Y'))
    news_items.each do |news_item|
      feed_items << {:title => "News: #{news_item.title}", :descr => news_item.descr, :date => news_item.created_at, :guid => "/news/view_news?NewsItem=#{news_item.id}"} if news_item.created_at> effDtTime
    end
    return feed_items
  end
  
  def table_object_rule_to_feed_items(table_name,rule)
    if rule.field_name == "NEW" then
      grouped_audits = get_audits_for_object(table_name,'New',rule.start_date)
      feed_items = Array.new
      combine_grouped_audits(nil,grouped_audits)[1].each do |history_item|
        if history_item[:changed_fields] != nil and history_item[:changed_fields].size != 0 then
          obj_id = eval("history_item[:object].#{@@object_to_edit_page[history_item[:object].class.to_s][:field]}") if history_item[:object] != nil
          edit_page_link = "#{@@object_to_edit_page[history_item[:object].class.to_s][:page]}/#{obj_id}"
          feed_items << {:title => history_item[:description], :descr => make_description_from_history_item(history_item), :date => history_item[:date_time], :guid => "#{edit_page_link}?HistoryItem=#{history_item[:changed_fields][0][:id]}"}
        end
      end
      return feed_items
    end
    if rule.field_name == "ALL"
      grouped_audits = get_audits_for_object(table_name,'All',rule.start_date,Time.now,rule.get_additions==false)
      feed_items = Array.new
      combine_grouped_audits(nil,grouped_audits)[1].each do |history_item|
        if history_item[:changed_fields] != nil and history_item[:changed_fields].size != 0 then
          flash[:notice] = history_item[:object].class.to_s if @@object_to_edit_page[history_item[:object].class.to_s] == nil
          obj_id = eval("history_item[:object].#{@@object_to_edit_page[history_item[:object].class.to_s][:field]}") if history_item[:object] != nil
          edit_page_link = "#{@@object_to_edit_page[history_item[:object].class.to_s][:page]}/#{obj_id}"
          feed_items << {:title => history_item[:description], :descr => make_description_from_history_item(history_item), :date => history_item[:date_time], :guid => "#{edit_page_link}?HistoryItem=#{history_item[:changed_fields][0][:id]}"}
        end
      end
      if rule.get_news == true and ['Networkprovider','Pointsofinterest','Equinixregion','Networktermptowner','Market'].include?(table_name) then
        newsTableName = (table_name == 'Networkprovider' ? 'News2np' : (table_name == 'Pointsofinterest' ? 'News2poi' : (table_name == 'Networktermptowner' ? 'News2ntpowner' : (table_name == 'Market' ? 'News2market' : 'News2region'))))
        news_tags = eval("#{newsTableName}.find(:all)")
        news_feed_items = Array.new
        effDtTime = Time.parse(rule.start_date.strftime('%m/%d/%Y'))
        news_tags.each do |news_tag|
          news_feed_items << {:title => "News: #{news_tag.newsitem.title}", :descr => news_tag.newsitem.descr, :date => news_tag.newsitem.created_at, :guid => "/news/view_news?NewsItem=#{news_tag.newsitem.id}"} if news_tag.newsitem.created_at > effDtTime
        end
        news_feed_items.uniq!
        feed_items += news_feed_items
      end
      return feed_items
    end
    tableLabel = table_label(table_name)
    if rule.field_name == 'search_fields'
      objs = eval("#{table_name}.find(:all, :conditions => [\"#{tableLabel.look_up_field} #{rule.comparison_operator} :value\",{:value => '#{rule.comparison_value}'}])")
    else
      if rule.comparison_operator == 'like' then
        objs = eval("#{table_name}.find(:all, :conditions => [\"#{rule.field_name} #{rule.comparison_operator} :value\",{:value => '#{rule.comparison_value}'}])")
      else
        objs = eval("#{table_name}.find(:all, :conditions => [\"#{rule.field_name} #{rule.comparison_operator} #{rule.comparison_value}\"])")
      end
    end
    feed_items = Array.new
    objs.each do |obj|
      grouped_audits = get_audits_for_object(table_name,obj.id,rule.start_date)
      combine_grouped_audits(obj,grouped_audits)[1].each do |history_item|
        if history_item[:changed_fields] != nil and history_item[:changed_fields].size != 0 then
          obj_id = eval("history_item[:object].#{@@object_to_edit_page[history_item[:object].class.to_s][:field]}") unless history_item.nil? or history_item[:object].nil? or @@object_to_edit_page[history_item[:object].class.to_s].nil?
          edit_page_link = "#{@@object_to_edit_page[history_item[:object].class.to_s][:page]}/#{obj_id}" unless history_item.nil? or history_item[:object].nil? or @@object_to_edit_page[history_item[:object].class.to_s].nil?
          feed_item = Hash.new
          feed_item[:title] = history_item[:description] 
          feed_item[:descr] = make_description_from_history_item(history_item) 
          feed_item[:date] = history_item[:date_time]
          feed_item[:guid] = "#{edit_page_link}?HistoryItem=#{ history_item[:changed_fields][0][:id] }"
          feed_items << feed_item
        end
      end
      effDtTime = Time.parse(rule.start_date.strftime('%m/%d/%Y'))
      if rule.get_news == true and ['Networkprovider','Pointsofinterest','Equinixregion','Networktermptowner','Market'].include?(table_name) then
        obj.newsitems.each do |newsitem|
          feed_items << {:title => "News: #{newsitem.title}", :descr => newsitem.descr, :date => newsitem.created_at, :guid => "/news/view_news?NewsItem=#{newsitem.id}"} if newsitem.created_at > effDtTime
        end
      end
    end
    return feed_items
  end
  
  def make_description_from_history_item(history_item)
    header_style = 'style="background-color: #add; padding: 2px 4px;"'
    cell_style = 'style="background-color: #fff; padding: 2px 4px;"'
    descr = "<table border='1' style='border-width: 1px; border-spacing: 1px; border-color: #000;'><tr><th width='170px' #{header_style}>Date</th><th width='170px' #{header_style}>Field</th><th width='300px' #{header_style}>Old Value</th><th width='300px' #{header_style}>New Value</th></tr>"
    if history_item[:changed_fields] != nil and history_item[:changed_fields].size != 0 then
      descr += "<tr><td #{cell_style} rowspan='#{ (history_item[:changed_fields].size==0 ? 1 : history_item[:changed_fields].size) }'>#{ history_item[:date_time].strftime('%m/%d/%Y %H:%M') }<br/>#{ history_item[:responsible_user].print_name_with_association if history_item[:responsible_user] != nil }</td>"
      first_item = true
      history_item[:changed_fields].each do |field_change|
        if first_item then
          first_item = false
          descr += "<td #{cell_style}>#{ field_change[:field_name] }</td><td #{cell_style}>#{ field_change[:old_value] }</td><td #{cell_style}>#{ field_change[:new_value] }</td>"
        else
          descr += "</tr><tr><td #{cell_style}>#{ field_change[:field_name] }</td><td #{cell_style}>#{ field_change[:old_value] }</td><td #{cell_style}>#{ field_change[:new_value] }</td>"
        end
      end
      descr += '</tr>'
    end
    descr += '</table>'
  end
  
  def get_feed_items_from_rule(rule)
    all_table_objs = ['Networkprovider','Pointsofinterest','Equinixregion','Networktermptowner','Market'] 
    if rule.object_name == "ALL" then
      feed_items = news_items_to_feed_items(rule)
      all_table_objs.each do |table_name|
        feed_items += table_object_rule_to_feed_items(table_name,rule)
      end
    elsif rule.object_name == "Newsitem"
      feed_items = news_items_to_feed_items(rule)
    else #if rule.object_name == Some Table Name
      feed_items = table_object_rule_to_feed_items(rule.object_name,rule)
    end
    return feed_items
  end
  
  def or_feeds(feed_list_1, feed_list_2)
    guids = Hash.new
    feed_list = Array.new
    feed_list_1.each do |feed_item| 
      if !guids[feed_item[:guid]] then 
        feed_list << feed_item
        guids[feed_item[:guid]] = true
      end
    end
    feed_list_2.each do |feed_item| 
      if !guids[feed_item[:guid]] then 
        feed_list << feed_item
        guids[feed_item[:guid]] = true
      end
    end
    return feed_list
  end
  
  def and_feeds(feed_list_1, feed_list_2)
    guids = Hash.new
    feed_list = Array.new
    feed_list_1.each do |feed_item|
      guids[feed_item[:guid]] = true
    end
    feed_list_2.each do |feed_item| 
      if guids[feed_item[:guid]] then 
        feed_list << feed_item
        guids[feed_item[:guid]] = nil
      end
    end
    return feed_list
  end
  
  def get_feed_items_from_tree(conditionTree,notATree = false)
    if conditionTree[:has_children] then
      if conditionTree[:and_or] == 'A' then
        return and_feeds(get_feed_items_from_tree(conditionTree[:lhs]),get_feed_items_from_tree(conditionTree[:rhs]))
      else
        return or_feeds(get_feed_items_from_tree(conditionTree[:lhs]),get_feed_items_from_tree(conditionTree[:rhs]))
      end
    else
      return or_feeds(get_feed_items_from_rule(conditionTree[:rule]),Array.new) if notATree
      return get_feed_items_from_rule(conditionTree[:rule])
    end
  end
end
