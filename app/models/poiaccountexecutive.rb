class Poiaccountexecutive < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
  belongs_to :pointsofinterest

  validates_presence_of :pointsofinterest_id
  
  def identifier
    if self.pointsofinterest.nil?
      return "Orphaned Account Executive (#{self.id})"
    else
      return "#{self.pointsofinterest.name}"
    end
  end
end