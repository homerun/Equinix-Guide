class Latencytime < ActiveRecord::Base
  belongs_to :networkprovider
  belongs_to :np2ntpA, :class_name => 'Np2ntp', :foreign_key => 'a_np2ntp_id'
  belongs_to :np2ntpB, :class_name => 'Np2ntp', :foreign_key => 'b_np2ntp_id'
  belongs_to :user
  belongs_to :contesting_user_list, :class_name => 'Userlist', :foreign_key => 'contesting_user_list'
  
  validates_presence_of :a_np2ntp_id, :b_np2ntp_id, :networkprovider_id
  
  def print_summary
    return "#{self.latency_time} ms - #{self.np2ntpA.networkterminationpoint.name} to #{self.np2ntpB.networkterminationpoint.name} through #{self.networkprovider.name}"
  end
end