class ConnectionConversionController < ApplicationController
  
  
  def get_ntps
    @list_of_ntps = Networkterminationpoint.find(:all, :conditions => conditions, :order => 'name').collect{|ntp| [ntp.name,ntp.id]} 
    render :partial => 'ntp_selector'
  end 
   
  def show
    unless params[:ntp_id] == '0'
      @networkterminationpoint = Networkterminationpoint.find(params[:ntp_id])
      set_vars
    end
    render :partial => "edit"
  end
  
  def show_market
    @market = Market.find_by_id(params[:market_id])
    unless @market.nil?
      @market_competitors = @market.datacenters.sort {|x,y| x.networkterminationpoint.name.downcase <=> y.networkterminationpoint.name.downcase }
      @networkterminationpoint = Networkterminationpoint.find(params[:ntp_id])
    end
    render :partial => 'markets'
  end
  
  def select_region
    unless params[:region_id] == 'All'
      subregion_list = Equinixregion.find(params[:region_id]).subregions.collect{|sub| sub.id}
      @list_of_countries = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|c| [c.name,c.id] }
    else  
      @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    end
    render :partial => 'select_country'
  end
  
  def show_countries
    unless params[:region_id].blank?
      subregion_list = Equinixregion.find(params[:region_id]).subregions.collect{|sub| sub.id}
      @list_of_countries = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})", :order => 'name').collect{|c| [c.name, c.id]}
    else  
      @list_of_countries = Country.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    end  
    render :partial => 'show_countries'
  end
  
  def show_campuses
    unless params[:networktermptowner_id].blank?
      @list_of_campuses = Campus.find(:all, :conditions => "networktermptowner_id = #{params[:networktermptowner_id]}", :order => 'name').collect{|c| [c.name, c.id]}
    else  
      @list_of_campuses = Campus.find(:all, :order => 'name').collect{|c| [c.name, c.id]}
    end  
    render :partial => 'show_campuses'
  end
  
  def show_markets
    unless params[:country_id].blank?
      @list_of_markets = Market.find(:all, :conditions => "country_id = #{params[:country_id]}", :order => 'market_name').collect{|m| [m.market_name, m.id]}
    else  
      @list_of_markets = Market.find(:all, :order => 'market_name').collect{|m| [m.market_name, m.id]}
    end
    render :partial => 'select_market'
  end
  
    def conditions
      conditions = []
      parameters = []
      if params[:search]
        if params[:search][:networktermpttype_id] != "All" 
          conditions << "ntp.networktermpttype_id = ?" 
          parameters << params[:search][:networktermpttype_id]
        end
        if params[:search][:networktermptowner_id] != "All" 
          conditions << "ntp.networktermptowner_id = ?" 
          parameters << params[:search][:networktermptowner_id]
        end
        if params[:search][:region_id] != "All" 
          subregion_list = Equinixregion.find(params[:search][:region_id]).subregions.collect{|sub| sub.id}
          country_list = Country.find(:all, :conditions => "unsubregion_id in (#{subregion_list.join(',')})").collect{|c| c.id}
          conditions << "ntp.country_id in (#{country_list.join(',')})" 
        end
        if params[:search][:country_id] != "All" 
          conditions << "ntp.country_id = ?" 
          parameters << params[:search][:country_id]
        end
      end
      [conditions.join(" AND "), *parameters]
    end
end
