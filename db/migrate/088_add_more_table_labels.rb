class AddMoreTableLabels < ActiveRecord::Migration
  def self.up
    
    tablelabel = Tablelabel.new
    tablelabel.table_name = 'ServiceGuideline'
    tablelabel.label = 'Service Guideline'
    tablelabel.plural = 'Service Guidlines'
    tablelabel.look_up_field = 'identifier'
    tablelabel.save!
    
    tablelabel = Tablelabel.new
    tablelabel.table_name = 'PointsofinterestAggregation'
    tablelabel.label = 'Point Of Interest Aggregation'
    tablelabel.plural = 'Point Of Interest Aggregations'
    tablelabel.look_up_field = 'identifier'
    tablelabel.save!
    
    tablelabel = Tablelabel.new
    tablelabel.table_name = 'Poiaccountexecutive'
    tablelabel.label = 'Account Executive'
    tablelabel.plural = 'Account Executives'
    tablelabel.look_up_field = 'identifier'
    tablelabel.save!
    
    tablelabel = Tablelabel.new
    tablelabel.table_name = 'PointsofinterestProviderCategory'
    tablelabel.label = 'Provider Category'
    tablelabel.plural = 'Provider Categories'
    tablelabel.look_up_field = 'identifier'
    tablelabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('latencyTime')
    tablefieldlabel.field_name = 'latency_time'
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('userCertified')
    tablefieldlabel.field_name = 'user_certified'
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('certifiedDate')
    tablefieldlabel.field_name = 'certified_date'
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('contestList')
    tablefieldlabel.field_name = 'contest_list'
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('fixed_income_class')
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('futures_class')
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('foreign_exchange_class')
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.find_by_field_name('equities_class')
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "account_id"
    tablefieldlabel.description = "Associated Equinix Account ID"
    tablefieldlabel.label = "Account ID"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "active_equinix_customer"
    tablefieldlabel.description = "Active Equinix Customer Flag"
    tablefieldlabel.label = "Active Equinix Customer"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "is_future_build"
    tablefieldlabel.description = "Is a Future Build"
    tablefieldlabel.label = "Future Build"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "future_build_date"
    tablefieldlabel.description = "Scheduled Future Build Date"
    tablefieldlabel.label = "Future Build Date"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "PointsofinterestAggregation"
    tablefieldlabel.field_name = "aggregator_pointsofinterest_id"
    tablefieldlabel.description = "Aggregator"
    tablefieldlabel.label = "Aggregator"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "PointsofinterestAggregation"
    tablefieldlabel.field_name = "aggregated_pointsofinterest_id"
    tablefieldlabel.description = "Aggregated"
    tablefieldlabel.label = "Aggregated"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "PointsofinterestProviderCategory"
    tablefieldlabel.field_name = "pointsofinterest_provider_category_type_id"
    tablefieldlabel.description = "Provider Category"
    tablefieldlabel.label = "Provider Category"
    tablefieldlabel.look_up_table = "PointsofinterestProviderCategoryType"
    tablefieldlabel.look_up_field = "category"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "prospectstatustype_id"
    tablefieldlabel.description = "Prospect Status"
    tablefieldlabel.label = "Status"
    tablefieldlabel.look_up_table = "Prospectstatustype"
    tablefieldlabel.look_up_field = "status_description"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "user_id"
    tablefieldlabel.description = "Certified by User"
    tablefieldlabel.label = "Certified by User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "public"
    tablefieldlabel.description = "Can Be Viewed Non-Equinix Users"
    tablefieldlabel.label = "Public"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ '1' => 'Yes', nil => 'No' }"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poiaccountnote"
    tablefieldlabel.field_name = "user_id"
    tablefieldlabel.description = "User"
    tablefieldlabel.label = "User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poiaccountnote"
    tablefieldlabel.field_name = "date_time"
    tablefieldlabel.description = "Time of note"
    tablefieldlabel.label = "Time"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "user_id"
    tablefieldlabel.description = "Certified by User"
    tablefieldlabel.label = "Certified by User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "ServiceGuideline"
    tablefieldlabel.field_name = "guideline_text"
    tablefieldlabel.description = "Guideline"
    tablefieldlabel.label = "Guideline"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "ServiceGuideline"
    tablefieldlabel.field_name = "effective_date"
    tablefieldlabel.description = "Effective Date"
    tablefieldlabel.label = "Effective Date"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
    
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "ServiceGuideline"
    tablefieldlabel.field_name = "service_id"
    tablefieldlabel.description = "Service"
    tablefieldlabel.label = "Service"
    tablefieldlabel.look_up_table = "Service"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
  end

  def self.down
    

    ['ServiceGuideline','PointsofinterestAggregation','Poiaccountexecutive','PointsofinterestProviderCategory'].each do |table_name|
      tablelabel = Tablelabel.find_by_table_name(table_name)
      Tablelabel.delete(tablelabel.id)
    end

    [{:old => 'latency_time', :new => 'latencyTime'},
     {:old => 'user_certified', :new => 'userCertified'},
     {:old => 'certified_date', :new => 'certifiedDate'},
     {:old => 'contest_list', :new => 'contestList'}].each do |field_name_change|
      tablefieldlabel = Tablefieldlabel.find_by_field_name(field_name_change[:old])
      tablefieldlabel.field_name = field_name_change[:new]
      tablefieldlabel.save!
    end

    [{:table => 'Pointsofinterest', :field => 'account_id'},
     {:table => 'Pointsofinterest', :field => 'active_equinix_customer'},
     {:table => 'Networkterminationpoint', :field => 'is_future_build'},
     {:table => 'Networkterminationpoint', :field => 'future_build_date'},
     {:table => 'PointsofinterestAggregation', :field => 'aggregator_pointsofinterest_id'},
     {:table => 'PointsofinterestAggregation', :field => 'aggregated_pointsofinterest_id'},
     {:table => 'PointsofinterestProviderCategory', :field => 'pointsofinterest_provider_category_type_id'},
     {:table => 'Poi2ntp', :field => 'prospectstatustype_id'},
     {:table => 'Poi2ntp', :field => 'user_id'},
     {:table => 'Poi2ntp', :field => 'public'},
     {:table => 'Poiaccountnote', :field => 'user_id'},
     {:table => 'Poiaccountnote', :field => 'date_time'},
     {:table => 'Np2ntp', :field => 'user_id'},
     {:table => 'ServiceGuideline', :field => 'guideline_text'},
     {:table => 'ServiceGuideline', :field => 'effective_date'},
     {:table => 'ServiceGuideline', :field => 'service_id'}].each do |table_and_field|
      Tablefieldlabel.find_by_table_name_and_field_name(table_and_field[:table],table_and_field[:field]).destroy
    end
  end
end
