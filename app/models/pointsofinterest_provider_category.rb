class PointsofinterestProviderCategory < ActiveRecord::Base
  belongs_to :pointsofinterest_provider_category_type
  belongs_to :pointsofinterest
  
  def identifier
    return "Orphaned Provider Category (#{self.id})" if self.pointsofinterest.nil?
    return "Provider Category for #{self.pointsofinterest.name}"
  end
end