class Pointsofinterest < ActiveRecord::Base
  belongs_to :subregion, :class_name => 'Unsubregion', :foreign_key => 'unsubregion_id'
  belongs_to :parent_poi, :class_name => 'Pointsofinterest', :foreign_key => 'parent_pointsofinterest_id'
  belongs_to :poitype
  has_many :services, :order => 'name', :dependent => :destroy
  has_many :account_executives, :class_name => 'Poiaccountexecutive', :dependent => :destroy
  
  has_many :ntp_connections, :class_name => 'Poi2ntp', :dependent => :destroy, :conditions => 'poi2ntps.prospectstatustype_id = 1'
  has_many :networkterminationpoints, :through => :ntp_connections
  
  has_many :prospect_ntp_connections, :class_name => 'Poi2ntp', :dependent => :destroy, :conditions => 'poi2ntps.prospectstatustype_id <> 1'
  has_many :prospect_networkterminationpoints, :through => :prospect_ntp_connections
  
  has_many :all_ntp_connections, :class_name => 'Poi2ntp', :dependent => :destroy
  has_many :all_networkterminationpoints, :through => :all_ntp_connections
  
  has_many :preferred_nps, :class_name => 'Poipreferrednp', :dependent => :destroy
  has_many :networkproviders, :through => :preferred_nps
  
  has_many :children_pois, :class_name => 'Pointsofinterest', :foreign_key => 'parent_pointsofinterest_id', :order => 'name'
  has_many :news2pois, :dependent => :destroy
  has_many :newsitems, :through => :news2pois
  has_many :account_notes, :class_name => 'Poiaccountnote', :order => 'date_time DESC', :dependent => :destroy
  has_many :poi2poiowners, :dependent => :destroy
  has_many :poiowners, :through => :poi2poiowners
  
  has_many :aggregated_pointsofinterests, :class_name => 'PointsofinterestAggregation', :foreign_key => 'aggregator_pointsofinterest_id'
  has_many :aggregations, :through => :aggregated_pointsofinterests, :source => :aggregated, :foreign_key => 'aggregated_pointsofinterest_id'
  
  has_many :aggregator_pointsofinterests, :class_name => 'PointsofinterestAggregation', :foreign_key => 'aggregated_pointsofinterest_id'
  has_many :aggregators, :through => :aggregator_pointsofinterests, :source => :aggregator, :foreign_key => 'aggregator_pointsofinterest_id'
  
  has_many :pointsofinterest_provider_categories
  has_many :provider_categories, :through => :pointsofinterest_provider_categories, :source => :pointsofinterest_provider_category_type
  
  has_many :user_pois, :dependent => :destroy
 
  validates_presence_of :name, :poitype_id, :unsubregion_id
  validates_uniqueness_of :name
  
  # Change the name of the column for validation
  HUMANIZED_COLUMNS = {
    :unsubregion_id => "Subregion", 
    :poitype_id => "Type"
    }
  
  def self.human_attribute_name(attribute)
    HUMANIZED_COLUMNS[attribute.to_sym] || super
  end
  
  def associated_pois_list
    associated_pois = Array.new
    associated_pois << [self.name,"#{self.id}"]
    associated_pois << [self.parent_poi.name,"#{self.parent_poi.id}"] if self.parent_poi != nil
    self.children_pois.each do |poi|
      associated_pois << [poi.name,"#{poi.id}"]
    end
    return associated_pois
  end
  
  def create_new_audit(user, poi)
    Pointsofinterest.columns.each do |p|
      unless poi[p.name].blank?
        audit = Audittrail.new
        audit.user_id = user.id
        audit.table_name = "Pointsofinterest"
        audit.table_id = self.id
        audit.transaction_id = 1
        audit.field_name = p.name
        audit.action = 'C'
        audit.new_value = poi[p.name]
        audit.save!
      end
    end
  end  
  
  def create_update_audit(user, poi)
    transactionMax = Audittrail.maximum(:transaction_id, :conditions => "table_name = 'Pointsofinterest' and table_id = #{self.id}")
    transactionMax = 0 if transactionMax.nil?
    Pointsofinterest.columns.each do |p|
      last_audit = Audittrail.find(:first, :conditions => "table_name = 'Pointsofinterest' and table_id = #{self.id} and field_name = '#{p.name}'", :order => "created_at DESC" )
      audit = Audittrail.new
      audit.user_id = user.id
      audit.table_name = "Pointsofinterest"
      audit.table_id = self.id
      audit.transaction_id = transactionMax + 1
      audit.field_name = p.name
      audit.action = 'U'
      audit.old_value = last_audit.new_value if last_audit 
      if poi[p.name].blank?
        audit.new_value = nil
      else  
        audit.new_value = poi[p.name] 
      end  
      audit.save! unless audit.old_value == audit.new_value
    end
  end  
  
  def create_destroy_audit(user)
    transactionMax = Audittrail.maximum(:transaction_id, :conditions => "table_name = 'Pointsofinterest' and table_id = #{self.id}")
    transactionMax = 0 if transactionMax.nil?
    Pointsofinterest.columns.each do |p|
      last_audit = Audittrail.find(:first, :conditions => "table_name = 'Pointsofinterest' and table_id = #{self.id} and field_name = '#{p.name}'", :order => "created_at DESC" )
      audit = Audittrail.new
      audit.user_id = user.id
      audit.table_name = "Pointsofinterest"
      audit.table_id = self.id
      audit.transaction_id = transactionMax + 1
      audit.field_name = p.name
      audit.action = 'D'
      audit.old_value = last_audit.new_value if last_audit 
      audit.new_value = nil
      audit.save!
    end
  end  
  
  def asset_class_summary
    classes = []
    classes << "Equities" if self.equities_class
    classes << "Fixed Income" if self.fixed_income_class
    classes << "Foreign Exchange" if self.foreign_exchange_class
    classes << "Derivatives" if self.futures_class
    return classes.join(', ')
  end
  
  def is_provider_category?(category_id)
    return false if self.provider_categories.nil?
    return (self.provider_categories.collect {|cat| cat.id}).include?(category_id)
  end
end