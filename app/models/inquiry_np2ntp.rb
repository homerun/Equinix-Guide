class InquiryNp2ntp < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :networkterminationpoint
  belongs_to :networkprovider
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'
  
  validates_presence_of :networkterminationpoint_id, :networkprovider_id
  
  def to_str
    return "#{self.networkprovider.name} to #{self.networkterminationpoint.name}"
  end
end
