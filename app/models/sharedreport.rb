class Sharedreport < ActiveRecord::Base
  belongs_to :shared_user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :report
  
  validates_presence_of :user_id, :report_id
end
