class CreateProviderCategories < ActiveRecord::Migration
  def self.up
    create_table :pointsofinterest_provider_category_types do |t|
      t.string :letter, :category
      t.timestamps
    end
    
    [['A','General Data via an Aggregator or Direct'],
     ['B','Market Data Workstation/Terminal Products'],
     ['C','Real Time Data Feeds From Source'],
     ['D','Real Time Aggregated Datafeeds'],
     ['E','End of Day Pricing Datafeeds'],
     ['F','Counterparty/Legal Entity Data'],
     ['G','Corporate Actions Data'],
     ['H','Credit Derivatives/ABS and Evaluated Pricing Data'],
     ['I','Brokerage Research Data'],
     ['J','Consensus Earnings Estimates Data'],
     ['K','Fundamental Data'],
     ['L','Investment Banking Data'],
     ['M','News and Markets/Economic Commentary'],
     ['N','Market Data Distribution Software/Hardware'],
     ['O','Market Data Storage Software Solutions'],
     ['P','Complex Event Processing Software'],
     ['Q','Market Data Inventory Management and Control'],
     ['R','Enterprise and Reference Data Management Solutions'],
     ['S','Coporate Actions Software and Service Solutions'],
     ['T','Miscellaneous Market Data Software/Hardware Solutions'],
     ['U','General Solutions and Consultancy'],
     ['V','Communications and Networking Solutions'],
     ['W','Industry Bodies/Organisations']].each_with_index do |category,index|
      poi_provider_cat = PointsofinterestProviderCategoryType.new
      poi_provider_cat.letter = category[0]
      poi_provider_cat.category = category[1]
      poi_provider_cat.save!
    end
    
    create_table :pointsofinterest_provider_categories do |t|
      t.integer :pointsofinterest_id, :pointsofinterest_provider_category_type_id
      t.timestamps
    end
    
    ["Market Data Aggregator", "Trading Platform"].each do |t|
      poitype = Poitype.find_by_name(t)
      Poitype.delete(t.id);
    end
    
    poitype = Poitype.new
    poitype.name = "Provider"
    poitype.save!
  end

  def self.down
    
    poitype = Poitype.find_by_name("Provider")
    Poitype.delete(poitype.id)
    
    ["Market Data Aggregator", "Trading Platform"].each do |t|
      poitype = Poitype.new
      poitype.name = t
      poitype.save!
    end
    
    drop_table :pointsofinterest_provider_categories
    drop_table :pointsofinterest_provider_category_types
  end
end
