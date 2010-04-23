class PointsofinterestAggregation < ActiveRecord::Base
  belongs_to :aggregator, :class_name => 'Pointsofinterest', :foreign_key => 'aggregator_pointsofinterest_id'
  belongs_to :aggregated, :class_name => 'Pointsofinterest', :foreign_key => 'aggregated_pointsofinterest_id'
  
  def identifier
    if self.aggregator.nil?
      return "Orphaned Aggregation (#{self.id}"
    end
    return "Aggregation of #{self.aggregator.name}"
  end
end