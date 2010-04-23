class ContestlistPoi2ntp < ActiveRecord::Base
  belongs_to :poi2ntp
  belongs_to :user
  belongs_to :connectiontype
  
  validates_presence_of :poi2ntp_id, :user_id, :poiconnectiontype_id
end
