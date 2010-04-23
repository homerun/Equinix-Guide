class ConnectionServiceDescription < ActiveRecord::Base
  
  def to_str
    return "#{self.abbreviation} - #{self.description}" unless self.abbreviation.blank?
    return self.description
  end
end
