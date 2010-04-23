class CreateMarkets < ActiveRecord::Migration
  def self.up
    create_table :markets do |t|
      t.integer :country_id
      t.string :market_name
      t.text :market_description
      t.timestamps
    end
    
    market = Market.new
    market.market_name = "New York"
    market.country_id = Country.find_by_name("United States").id
    market.save!
    
    market = Market.new
    market.market_name = "London"
    market.country_id = Country.find_by_name("United Kingdom").id
    market.save!
    
    market = Market.new
    market.market_name = "Sydney"
    market.country_id = Country.find_by_name("Australia").id
    market.save!
    
    market = Market.new
    market.market_name = "Singapore"
    market.country_id = Country.find_by_name("Singapore").id
    market.save!
    
    market = Market.new
    market.market_name = "Dallas"
    market.country_id = Country.find_by_name("United States").id
    market.save!
    
    market = Market.new
    market.market_name = "Chicago"
    market.country_id = Country.find_by_name("United States").id
    market.save!
    
    market = Market.new
    market.market_name = "D.C. / Virginia"
    market.country_id = Country.find_by_name("United States").id
    market.save!
    
    market = Market.new
    market.market_name = "Silicon Valley"
    market.country_id = Country.find_by_name("United States").id
    market.save!
    
    market = Market.new
    market.market_name = "Los Angeles"
    market.country_id = Country.find_by_name("United States").id
    market.save!
    
    market = Market.new
    market.market_name = "Tokyo"
    market.country_id = Country.find_by_name("Japan").id
    market.save!
    
    market = Market.new
    market.market_name = "Hong Kong"
    market.country_id = Country.find_by_name("Hong Kong").id
    market.save!
    
    market = Market.new
    market.market_name = "Paris"
    market.country_id = Country.find_by_name("France").id
    market.save!
  end

  def self.down
    drop_table :markets
  end
end
