class CustomerGroupRule < ActiveRecord::Base
  belongs_to :customer_group
  
  def print
    if self.all_pages
      return "<b><i>All Pages</i></b>."
    else
      object_name_label = Tablelabel.find(:first,:conditions => ["table_name = :name",{:name => CustomerGroupRule.hash_of_pages[self.page_name][:object]}])
      if self.id_list == 'NONE' then
        "The page <b>#{CustomerGroupRule.hash_of_pages[self.page_name][:title]}</b>."
      elsif self.id_list == 'ALL' then
        "<i>All objects</i> on the page <b>#{CustomerGroupRule.hash_of_pages[self.page_name][:title]}</b>."
      else
        list_of_values = Array.new
        self.id_list.split(',').each do |val_id|
          list_of_values << object_name_label.title(val_id)
        end
        return "Objects on the page <b>#{CustomerGroupRule.hash_of_pages[self.page_name][:title]}</b> and <i>in the list</i>: #{list_of_values.join(', ')}."
      end
    end
  end
  
  def self.hash_of_pages
    return { 
      'edit_poi'             => {:title => 'Manage Points of Interest',          :object => 'Pointsofinterest'},
      'edit_ntp'             => {:title => 'Manage Network Termination Points',  :object => 'Networkterminationpoint'},
      'edit_networkprovider' => {:title => 'Manage Network Providers',           :object => 'Networkprovider'},
      'edit_market'          => {:title => 'Manage Markets',                     :object => 'Market'},
      'edit_campus'          => {:title => 'Manage Campuses',                    :object => 'Campus'},
      'edit_region'          => {:title => 'Manage Regions',                     :object => 'Equinixregion'},
      'services_and_networkproviders_report' => {:title => 'Datacenter to Exchanges Report', :object => nil}
    }
  end
  
  def self.non_object_page_titles
    pages = []
    self.hash_of_pages.each_pair do |key,val|
      if val[:object].nil? then
        pages << val[:title]
      end
    end
    return pages
  end
  
  def self.non_object_pages
    pages = []
    self.hash_of_pages.each_pair do |key,val|
      if val[:object].nil? then
        pages << key
      end
    end
    return pages
  end
end