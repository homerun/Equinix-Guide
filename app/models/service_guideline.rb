class ServiceGuideline < ActiveRecord::Base
  belongs_to :service
  
  def identifier
    if self.service.nil? then
      return "Orphaned Service Guideline (#{self.id})"
    else
      return "Guideline for #{self.service.name}"
    end
  end
end