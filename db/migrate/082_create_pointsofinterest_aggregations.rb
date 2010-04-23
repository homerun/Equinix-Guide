class CreatePointsofinterestAggregations < ActiveRecord::Migration
  def self.up
    create_table :pointsofinterest_aggregations do |t|
      t.integer :aggregator_pointsofinterest_id, :aggregated_pointsofinterest_id
      t.timestamps
    end
    
    ["Market Data Aggregator", "Trading Platform"].each do |t|
      poitype = Poitype.new
      poitype.name = t
      poitype.save!
    end
  end

  def self.down
    drop_table :pointsofinterest_aggregations
    ["Market Data Aggregator", "Trading Platform"].each do |t|
      poitype = Poitype.find_by_name(t)
      Poitype.delete(t.id);
    end
  end
end
