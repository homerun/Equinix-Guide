require_gem 'pdf/writer'
require_gem 'pdf/simpletable'
class Report < ActiveRecord::Base
  has_many :reportparameters, :dependent => :destroy
  has_many :sharedreports, :dependent => :destroy
  has_many :shared_users, :through => :sharedreports
  belongs_to :reporttype
  belongs_to :user
  
  validates_presence_of :user_id, :reporttype_id
  
  # Ideally, you would send in both selected_ntp and market, but just the market is sufficient
  def self.get_equinix_metro_report_pdf_object(market, selected_ntp=nil)
    Inflector.inflections do |inflect|
      inflect.irregular 'campus', 'campuses'
    end
    
    selected_ntp = market.datacenters[0].networkterminationpoint if selected_ntp.nil?
    
    report_pdf = PDF::Writer.new
    old_left_margin = report_pdf.left_margin
    old_top_margin = report_pdf.top_margin
    report_pdf.left_margin = 0
    report_pdf.top_margin = 0
    report_pdf.select_font "Times-Roman"
    report_pdf.stroke_color Color::RGB::Black
    report_pdf.rectangle(0,report_pdf.page_height-45,report_pdf.page_width,45).fill
    report_pdf.fill_color Color::RGB::Red
    report_pdf.rectangle(0,report_pdf.page_height-46,report_pdf.page_width,1).fill
    y_position = report_pdf.y + 0
    report_pdf.add_image_from_file(RAILS_ROOT+"/public/images/Equinix_GUIDE.png",10,y_position,84,30)
    report_pdf.add_image_from_file(RAILS_ROOT+"/public/images/equinix_logo.png",report_pdf.page_width-70,y_position+2,55,28)
    
    report_pdf.left_margin = old_left_margin
    report_pdf.top_margin = old_top_margin
    report_pdf.fill_color Color::RGB::Black
    report_pdf.text ' ', :font_size => 10, :justification => :center
    unless selected_ntp.datacenterdetail.market.nil? then
      report_pdf.text "Equinix: #{selected_ntp.datacenterdetail.market.market_name} Market Overview", :font_size => 24, :justification => :center, :font => 
      complete_set_of_ntps = selected_ntp.datacenterdetail.market.datacenters.collect {|dc| dc.networkterminationpoint }
    else
      report_pdf.text "Equinix: #{selected_ntp.parentcountry.name} Overview", :font_size => 24, :justification => :center
      complete_set_of_ntps = selected_ntp.parentcountry.networkterminationpoints
    end
    report_pdf.text ' ', :font_size => 20, :justification => :center
    complete_set_of_ntps.delete_if {|ntp| (ntp.owner.name != "Equinix")}
    
    #BEGIN LOCATION INFO AND MAPS
    
    report_pdf.text "<b>LOCATIONS</b>", :font_size => 18, :justification => :center
    report_pdf.text ' ', :font_size => 16
    
    map_letter = 'a'
    map_markers = []
    # Classify datacenter as on campus or not and display address info
    unless selected_ntp.campus.nil?
      report_pdf.text "<b>Datacenters in the #{selected_ntp.campus.name} Campus (Connected via IBX Link or Cross-Connect):</b>", :font_size => 13.5, :justification => :center
      report_pdf.text ' ', :font_size => 10, :justification => :center
      start_y = report_pdf.y-0
      (selected_ntp.campus.ntps.sort {|x,y| x.name.downcase <=> y.name.downcase}).each do |ntp|
        if ntp.is_future_build then under_construction_text = ' <i>**Under Construction**</i>' else under_construction_text = '' end
        report_pdf.text "<b>#{map_letter.upcase} - #{ntp.name}:#{ under_construction_text }</b>", :font_size => 12
        report_pdf.left_margin = report_pdf.left_margin + 10
        report_pdf.text "#{ntp.street_address}", :font_size => 11
        report_pdf.text "#{'Floor: ' if ntp.floor.downcase['floor'].nil?}#{ntp.floor}" unless ntp.floor.blank?
        report_pdf.text "#{'Suite: ' if ntp.suite.downcase['suite'].nil? and ntp.suite.downcase['st'].nil?}#{ntp.suite}" unless ntp.suite.blank?
        report_pdf.text "#{ntp.city}#{', ' unless ntp.city.blank? or ntp.state_or_province.blank?}#{ntp.state_or_province} #{ntp.zip_code}"
        report_pdf.text "#{ntp.country.name}"
        report_pdf.left_margin = report_pdf.left_margin - 10
        report_pdf.text ' ', :font_size => 20, :justification => :center
        map_markers << "#{ ntp.lat },#{ ntp.lon },red#{map_letter}" unless ntp.lat.blank? or ntp.lon.blank?
        map_letter = map_letter.succ unless ntp.lat.blank? or ntp.lon.blank?
        end_y = report_pdf.y-0
      end
      campus_ntps = selected_ntp.campus.ntps
      end_y = report_pdf.y-0
      if (complete_set_of_ntps - campus_ntps).size > 0 then
        report_pdf.text "<b>Datacenters not in the #{selected_ntp.campus.name} Campus:</b>", :font_size => 14, :justification => :center
      end
    else
      campus_ntps = []
      report_pdf.text "<b>Datacenters in #{((selected_ntp.datacenterdetail.market.nil?)?(selected_ntp.parentcountry.name):(selected_ntp.datacenterdetail.market.market_name))}:</b>", :font_size => 14, :justification => :center
      start_y = report_pdf.y-0
    end
    report_pdf.text ' ', :font_size => 10, :justification => :center

    ((complete_set_of_ntps - campus_ntps).sort {|x,y| x.name.downcase <=> y.name.downcase}).each do |ntp|
      if ntp.is_future_build then under_construction_text = ' <i>**Under Construction**</i>' else under_construction_text = '' end
      report_pdf.text "<b>#{map_letter.upcase} - #{ntp.name}:#{ under_construction_text }</b>", :font_size => 12
      report_pdf.left_margin = report_pdf.left_margin + 10
      report_pdf.text "#{ntp.street_address}", :font_size => 11
      report_pdf.text "#{'Floor: ' if ntp.floor.downcase['floor'].nil?}#{ntp.floor}" unless ntp.floor.blank?
      report_pdf.text "#{'Suite: ' if ntp.suite.downcase['suite'].nil? and ntp.suite.downcase['st'].nil?}#{ntp.suite}" unless ntp.suite.blank?
      report_pdf.text "#{ntp.city}#{', ' unless ntp.city.blank? or ntp.state_or_province.blank?}#{ntp.state_or_province} #{ntp.zip_code}"
      report_pdf.text "#{ntp.country.name}"
      report_pdf.left_margin = report_pdf.left_margin - 10
      report_pdf.text ' ', :font_size => 20, :justification => :center
      map_markers << "#{ ntp.lat },#{ ntp.lon },blue#{map_letter}" unless ntp.lat.blank? or ntp.lon.blank?
      map_letter = map_letter.succ unless ntp.lat.blank? or ntp.lon.blank?
    end
    end_y = report_pdf.y - 0 if selected_ntp.campus.nil? or end_y.nil?

    map_size = [start_y-end_y,200].min * 2
    y_position = (start_y - (((start_y-end_y-map_size/2)/2)+map_size/2)).to_i
    if market.nil? then
      image_id = selected_ntp.id
    else
      image_id = market.id
    end
    report_pdf.add_image_from_file(RAILS_ROOT+"/public/images/equinix_metro_report_map_#{image_id}.png",report_pdf.page_width-(map_size/2+50),y_position,map_size/2,map_size/2) unless map_markers.size == 0

    # END LOCATION INFO AND MAPS

    exchange_poi_types = [1,4,5,6,8]

    # BEGIN EXCHANGES TABLE
    
    exchange_table = PDF::SimpleTable.new
    
    exchange_table.font_size = 7
    exchange_table.maximum_width = 540
    exchange_table.position = :center
    exchange_table.orientation = :center
    exchange_table.shade_heading_color = Color::RGB::Black
    exchange_table.shade_headings = true
    exchange_table.heading_color = Color::RGB::White
    exchange_table.heading_font_size = 9
    
    exchange_hash = Hash.new
    
    exchange_table.columns["poi"] = PDF::SimpleTable::Column.new("poi") {|col| 
      col.heading = "POINT OF INTEREST"
      col.justification = :right
    }
    exchange_table.columns["url"] = PDF::SimpleTable::Column.new("url") {|col| col.heading = "url" }
    exchange_table.columns["asset_classes"] = PDF::SimpleTable::Column.new("asset_classes") {|col| col.heading = "Asset Classes" }
    exchange_table.columns["poi_type"] = PDF::SimpleTable::Column.new("poi_type") {|col| col.heading = "Type" }
    exchange_table.data = []
    
    had_prospect = false
    complete_set_of_ntps.each do |ntp|
      unless ntp.is_future_build
        exchange_table.columns["#{ntp.id}"] = PDF::SimpleTable::Column.new("#{ntp.id}") {|col| col.heading = "#{ntp.name.upcase}"; col.justification = :center }
        ntp.all_poi_connections.each do |poi_connection|
          if poi_connection.public and exchange_poi_types.include?(poi_connection.pointsofinterest.poitype_id) \
            and [1,2].include?(poi_connection.prospectstatustype_id) then
            if exchange_hash[poi_connection.pointsofinterest].nil? then
              poi_name = "<b>#{poi_connection.pointsofinterest.name}</b>"
              #poi_name = "#{poi_name} (#{poi_connection.pointsofinterest.abbreviation})" unless poi_connection.pointsofinterest.abbreviation.blank?
              #poi_name = poi_connection.pointsofinterest.name
              poi_type = poi_connection.pointsofinterest.poitype.name
              (poi_connection.pointsofinterest.provider_categories.sort{|x,y| x.category <=> y.category}).each {|cat| poi_type += "\n   - #{cat.category}" }
              exchange_hash[poi_connection.pointsofinterest] = {"poi" => poi_name, "asset_classes" => poi_connection.pointsofinterest.asset_class_summary, "poi_type" => poi_type } 
              exchange_hash[poi_connection.pointsofinterest]["url"] = poi_connection.pointsofinterest.url unless poi_connection.pointsofinterest.url.blank?
            end
            #exchange_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = ((poi_connection.connectiontype.name == 'A')?('O'):('X'))
            if poi_connection.connectiontype.name == 'A' then
              exchange_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = '<b>Matching Engines</b>'
            elsif poi_connection.connectiontype.name == 'B' then
              exchange_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = '<b>Access Node</b>'
            elsif poi_connection.connectiontype.name == 'D' then
              exchange_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = 'IBX'
            else
              exchange_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = ' '
            end
            if poi_connection.prospectstatustype_id == 2 then
              exchange_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = '**' + exchange_hash[poi_connection.pointsofinterest]["#{ ntp.id }"] + '**'
              had_prospect = true
            end
            ntp.campus.ntps.each do |campus_ntp|
              connection = CampusNtp2ntp.find(:first,:conditions => ["a_networkterminationpoint_id = :a_ntp_id and b_networkterminationpoint_id = :b_ntp_id", {:a_ntp_id => [ntp.id,campus_ntp.id].min, :b_ntp_id => [ntp.id,campus_ntp.id].max}])
              unless connection.nil?
                access_type = CampusAccessType.find_by_id(connection.campus_access_type_id)
                unless access_type.nil?
                  access_type = access_type.name
                end
              end
              if access_type.nil? then
                access_type = "IBX"
              end
              exchange_hash[poi_connection.pointsofinterest]["#{campus_ntp.id}"] = ((poi_connection.prospectstatustype_id == 2)?("**via #{access_type}**"):("via #{access_type}")) if exchange_hash[poi_connection.pointsofinterest]["#{campus_ntp.id}"].nil?
            end unless ntp.campus.nil?
        end
      end
      end
    end
    
    exchange_hash.each_pair do |poi, data|
      exchange_table.data << data
    end
    exchange_table.data.sort! {|x,y| x["poi"].downcase <=> y["poi"].downcase }

    complete_set_of_ntps.sort! {|x,y| x.name.downcase <=> y.name.downcase }
    exchange_table.column_order = ["poi"]
    complete_set_of_ntps.each{|ntp| exchange_table.column_order << "#{ntp.id}" unless ntp.is_future_build }
    exchange_table.column_order << "asset_classes"
    exchange_table.column_order << "poi_type"
        
    report_pdf.text ' ', :font_size => 20, :justification => :center unless exchange_table.data.size == 0
    if report_pdf.y-report_pdf.bottom_margin < 100 then
      report_pdf.text ' ', :font_size => 50, :justification => :center unless exchange_table.data.size == 0
    end
    report_pdf.text '<b>EXCHANGES</b>', :font_size => 18, :justification => :center unless exchange_table.data.size == 0
    report_pdf.text ' ', :font_size => 10, :justification => :center unless exchange_table.data.size == 0
    exchange_table.render_on(report_pdf) unless exchange_table.data.size == 0
    report_pdf.text '**CONNECTION** <i>Signed but not yet live</i>', :font_size => 8, :justification => :center unless exchange_table.data.size == 0 or not had_prospect
    
    # END EXCHANGES TABLE
    
    # BEGIN OTHER POIS_TABLE
    
    poi_table = PDF::SimpleTable.new
    
    poi_table.font_size = 7
    poi_table.maximum_width = 540
    poi_table.position = :center
    poi_table.orientation = :center
    poi_table.shade_heading_color = Color::RGB::Black
    poi_table.shade_headings = true
    poi_table.heading_color = Color::RGB::White
    poi_table.heading_font_size = 9
    
    poi_hash = Hash.new
    
    poi_table.columns["poi"] = PDF::SimpleTable::Column.new("poi") {|col| 
      col.heading = "POINT OF INTEREST"; 
      col.justification = :right
    }
    poi_table.columns["url"] = PDF::SimpleTable::Column.new("url") {|col| col.heading = "url" }
    poi_table.columns["connections"] = PDF::SimpleTable::Column.new("connections") {|col| col.heading = "Connects To" }
    poi_table.columns["poi_type"] = PDF::SimpleTable::Column.new("poi_type") {|col| col.heading = "Type" }
    poi_table.data = []
    
    had_prospect = false
    complete_set_of_ntps.each do |ntp|
      unless ntp.is_future_build
        poi_table.columns["#{ntp.id}"] = PDF::SimpleTable::Column.new("#{ntp.id}") {|col| col.heading = "#{ntp.name.upcase}"; col.justification = :center }
        ntp.all_poi_connections.each do |poi_connection|
          if poi_connection.public and not exchange_poi_types.include?(poi_connection.pointsofinterest.poitype_id) \
            and [1,2].include?(poi_connection.prospectstatustype_id) then
            if poi_hash[poi_connection.pointsofinterest].nil? then
              poi_name = "<b>#{poi_connection.pointsofinterest.name}</b>"
              #poi_name = "#{poi_name} (#{poi_connection.pointsofinterest.abbreviation})" unless poi_connection.pointsofinterest.abbreviation.blank?
              #poi_name = poi_connection.pointsofinterest.name
              poi_type = poi_connection.pointsofinterest.poitype.name
              (poi_connection.pointsofinterest.provider_categories.sort{|x,y| x.category <=> y.category}).each {|cat| poi_type += "\n   - #{cat.category}" } unless poi_connection.pointsofinterest.poitype.name != "Provider" or poi_connection.pointsofinterest.provider_categories.nil?
              poi_hash[poi_connection.pointsofinterest] = {"poi" => poi_name, "asset_classes" => poi_connection.pointsofinterest.asset_class_summary, "poi_type" => poi_type } 
              poi_hash[poi_connection.pointsofinterest]["connections"] = ((poi_connection.pointsofinterest.aggregations.sort{|x,y| x.name.downcase <=> y.name.downcase}).collect {|aggr| aggr.name}).join("\n") unless poi_connection.pointsofinterest.poitype.name != "Provider" or poi_connection.pointsofinterest.aggregations.nil?
              poi_hash[poi_connection.pointsofinterest]["url"] = poi_connection.pointsofinterest.url unless poi_connection.pointsofinterest.url.blank?
            end
            #poi_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = ((poi_connection.connectiontype.name == 'A')?('O'):('X'))
            if poi_connection.connectiontype.name == 'A' then
              poi_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = '<b>System</b>'
            elsif poi_connection.connectiontype.name == 'B' then
              poi_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = '<b>POP</b>'
            elsif poi_connection.connectiontype.name == 'D' then
              poi_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = 'IBX'
            else
              poi_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = ' '
            end
            if poi_connection.prospectstatustype_id == 2 then
              poi_hash[poi_connection.pointsofinterest]["#{ntp.id}"] = '**' + poi_hash[poi_connection.pointsofinterest]["#{ ntp.id }"] + '**'
              had_prospect = true
            end
            ntp.campus.ntps.each do |campus_ntp|
              connection = CampusNtp2ntp.find(:first,:conditions => ["a_networkterminationpoint_id = :a_ntp_id and b_networkterminationpoint_id = :b_ntp_id", {:a_ntp_id => [ntp.id,campus_ntp.id].min, :b_ntp_id => [ntp.id,campus_ntp.id].max}])
              unless connection.nil?
                access_type = CampusAccessType.find_by_id(connection.campus_access_type_id)
                unless access_type.nil?
                  access_type = access_type.name
                end
              end
              if access_type.nil? then
                access_type = "IBX"
              end
              poi_hash[poi_connection.pointsofinterest]["#{campus_ntp.id}"] = ((poi_connection.prospectstatustype_id == 2)?("**via #{access_type}**"):("via #{access_type}")) if poi_hash[poi_connection.pointsofinterest]["#{campus_ntp.id}"].nil?
            end unless ntp.campus.nil?
          end
        end
      end
    end
    
    poi_hash.each_pair do |poi, data|
      poi_table.data << data
    end
    poi_table.data.sort! {|x,y| x["poi"].downcase <=> y["poi"].downcase }

    complete_set_of_ntps.sort! {|x,y| x.name.downcase <=> y.name.downcase }
    poi_table.column_order = ["poi"]
    complete_set_of_ntps.each{|ntp| poi_table.column_order << "#{ntp.id}" unless ntp.is_future_build }
    poi_table.column_order << "poi_type"
    poi_table.column_order << "connections"
        
    report_pdf.text ' ', :font_size => 20, :justification => :center unless poi_table.data.size == 0
    if report_pdf.y-report_pdf.bottom_margin < 100 then
      report_pdf.text ' ', :font_size => 50, :justification => :center unless poi_table.data.size == 0
    end
    report_pdf.text '<b>POINTS OF INTEREST</b>', :font_size => 18, :justification => :center unless poi_table.data.size == 0
    report_pdf.text ' ', :font_size => 10, :justification => :center unless poi_table.data.size == 0
    poi_table.render_on(report_pdf) unless poi_table.data.size == 0
    report_pdf.text '**CONNECTION** <i>Signed but not yet live</i>', :font_size => 8, :justification => :center unless exchange_table.data.size == 0 or not had_prospect
    
    
    self.render_np_table(report_pdf, "OPTIMIZED IP ROUTING", complete_set_of_ntps, "routing_type == true")
    
    self.render_np_table(report_pdf, "CARRIERS", complete_set_of_ntps, "carrier_type == true")
    
    self.render_np_table(report_pdf, "EXTRANET PROVIDERS", complete_set_of_ntps, "extranet_type == true")
    
    
    latency_table = PDF::SimpleTable.new
    
    latency_table.font_size = 7
    latency_table.maximum_width = 540
    latency_table.position = :center
    latency_table.orientation = :center
    latency_table.shade_heading_color = Color::RGB::Black
    latency_table.shade_headings = true
    latency_table.heading_color = Color::RGB::White
    latency_table.heading_font_size = 9
    
    latency_table.columns["market"] = PDF::SimpleTable::Column.new("market") {|col| col.heading = "MARKET" }  
    latency_table.columns["latency"] = PDF::SimpleTable::Column.new("latency") {|col| col.heading = "LATENCY" }    
    latency_table.column_order = ["market","latency"]
    
    market_latencytime_data = Hash.new
    EquinixInterMarketLatencytime.find(:all,:conditions => ["a_market_id = :market",{:market => selected_ntp.datacenterdetail.market_id}]).each do |market_latencytime|
      market_latencytime_data[market_latencytime.b_market_id] = Array.new if market_latencytime_data[market_latencytime.b_market_id].nil?
      market_latencytime_data[market_latencytime.b_market_id] << market_latencytime
    end
   
   
    latency_table.data = []
    markets = Market.find(:all).sort {|x,y| x.market_name.downcase <=> y.market_name.downcase}
    markets.each do |market|
      if market_latencytime_data[market.id].nil? then
        contains_equinix = false
        market.datacenters.each {|dc| contains_equinix = true if dc.networkterminationpoint.owner.name == "Equinix" }
        latency_table.data << {'market' => market.market_name, 'latency' => "Unknown" } if contains_equinix
      else
        latency_table.data << {'market' => market.market_name, 'latency' => "#{(market_latencytime_data[market.id].collect {|l| l.latencytime.latency_time}).min} ms" }
      end
    end
    
    report_pdf.text ' ', :font_size => 20, :justification => :center unless latency_table.data.size == 0
    if report_pdf.y-report_pdf.bottom_margin < 100 then
      report_pdf.text ' ', :font_size => 50, :justification => :center unless latency_table.data.size == 0
    end
    report_pdf.text '<b>LATENCY TIMES TO MARKETS</b>', :font_size => 18, :justification => :center unless latency_table.data.size == 0
    report_pdf.text ' ', :font_size => 10, :justification => :center unless latency_table.data.size == 0
    latency_table.render_on(report_pdf) unless latency_table.data.size == 0
    
    return report_pdf
  end
  
  def self.render_np_table(report_pdf, np_table_title, complete_set_of_ntps, network_provider_condition)
    np_table = PDF::SimpleTable.new
    
    np_table.font_size = 7
    np_table.maximum_width = 540
    np_table.position = :center
    np_table.orientation = :center
    np_table.shade_heading_color = Color::RGB::Black
    np_table.shade_headings = true
    np_table.heading_color = Color::RGB::White
    np_table.heading_font_size = 9
    
    np_hash = Hash.new
    
    np_table.columns["np"] = PDF::SimpleTable::Column.new("np") {|col| 
      col.heading = "NETWORK PROVIDER"; 
    
      #col.link_name = "url" 
    }
    np_table.columns["url"] = PDF::SimpleTable::Column.new("url") {|col| col.heading = "url" }
    np_table.data = []
    
    in_facility_text = 'font::ZapfDingbats::color::255,0,0::n'
    ibx_text = 'font::ZapfDingbats::color::0,0,0::n'
    
    complete_set_of_ntps.each do |ntp|
      unless ntp.is_future_build
        np_table.columns["#{ntp.id}"] = PDF::SimpleTable::Column.new("#{ntp.id}") do |col| 
          col.heading = "#{ntp.name.upcase}"
          col.justification = :center
          col.heading.justification = :center
        end
        ntp.np_connections.each do |np_connection|
          if eval("np_connection.networkprovider."+network_provider_condition) then
            if np_hash[np_connection.networkprovider].nil? then
              np_hash[np_connection.networkprovider] = {"np" => "<b>#{np_connection.networkprovider.name}</b>" } 
              np_hash[np_connection.networkprovider]["url"] = np_connection.networkprovider.url unless np_connection.networkprovider.url.blank?
            end
            np_hash[np_connection.networkprovider]["#{ntp.id}"] = ((['A','C','D','G'].include?(np_connection.connectiontype.name))?(in_facility_text):(ibx_text))
            #np_hash[np_connection.networkprovider]["#{ntp.id}"] = ((np_connection.connectiontype.name == 'H')?('O'):('X'))
            ntp.campus.ntps.each do |campus_ntp|
              np_hash[np_connection.networkprovider]["#{campus_ntp.id}"] = ibx_text if np_hash[np_connection.networkprovider]["#{campus_ntp.id}"].nil?
            end unless ntp.campus.nil?
          end
        end
      end
    end
    
    np_hash.each_pair do |np, data|
      np_table.data << data
    end
    np_table.data.sort! {|x,y| x["np"].downcase <=> y["np"].downcase }

    complete_set_of_ntps.sort! {|x,y| x.name.downcase <=> y.name.downcase }
    np_table.column_order = ["np"]
    complete_set_of_ntps.each{|ntp| np_table.column_order << "#{ntp.id}" unless ntp.is_future_build }
    
    report_pdf.text ' ', :font_size => 20, :justification => :center unless np_table.data.size == 0
    if report_pdf.y-report_pdf.bottom_margin < 100 then
      report_pdf.text ' ', :font_size => 50, :justification => :center unless np_table.data.size == 0
    end
    report_pdf.text "<b>#{np_table_title}</b>", :font_size => 18, :justification => :center unless np_table.data.size == 0
    report_pdf.text ' ', :font_size => 10, :justification => :center unless np_table.data.size == 0
    np_table.render_on(report_pdf) unless np_table.data.size == 0
    report_pdf.text ' = Available in facility', :font_size => 10, :justification => :center unless np_table.data.size == 0
    report_pdf.select_font('ZapfDingbats')
    report_pdf.fill_color(Color::RGB.new(255,0,0))
    report_pdf.add_text(250,report_pdf.y,'n',8) unless np_table.data.size == 0
    report_pdf.select_font('Times-Roman')
    report_pdf.fill_color(Color::RGB::Black)
    report_pdf.text ' = Available from another IBX', :font_size => 10, :justification => :center unless np_table.data.size == 0
    report_pdf.select_font('ZapfDingbats')
    report_pdf.fill_color(Color::RGB.new(0,0,0))
    report_pdf.add_text(235,report_pdf.y,'n',8) unless np_table.data.size == 0
    report_pdf.select_font('Times-Roman')
    report_pdf.fill_color(Color::RGB::Black)
  end

end
