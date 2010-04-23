class InquiryLatencyTime < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :a_np2ntp, :class_name => 'Np2ntp', :foreign_key => 'a_np2ntp_id'
  belongs_to :b_np2ntp, :class_name => 'Np2ntp', :foreign_key => 'b_np2ntp_id'
  belongs_to :networkprovider
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'
  
  validates_presence_of :a_np2ntp_id, :b_np2ntp_id, :networkprovider_id
  
  def to_str
    return "#{a_np2ntp.networkterminationpoint.name} to #{b_np2ntp.networkterminationpoint.name} through #{networkprovider.name}"
  end
end
