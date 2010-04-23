class Inquiry < ActiveRecord::Base
  belongs_to :inquirer, :class_name => 'User', :foreign_key => 'inquiry_sender_id'
  
  has_many :inquiry_np2ntps, :dependent => :destroy, :conditions => 'inquiry_np2ntps.response_date is null'
  has_many :inquiry_latency_times, :dependent => :destroy, :conditions => 'inquiry_latency_times.response_date is null'
  has_many :networkterminationpoints, :through => :inquiry_ntps
  has_many :networkproviders, :through => :inquiry_ntps
    
  validates_presence_of :inquiry_sender_id, :inquire_to_email, :inquire_to_name, :inquire_to_user_id
end