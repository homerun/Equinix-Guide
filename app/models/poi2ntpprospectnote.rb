class Poi2ntpprospectnote < ActiveRecord::Base
  belongs_to :user
  belongs_to :poi2ntp
  
  validates_presence_of :user_id, :poi2ntp_id
end