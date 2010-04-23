class ContestlistNp2ntp < ActiveRecord::Base
  belongs_to :np2ntp
  belongs_to :user
  belongs_to :connectiontype
  
  validates_presence_of :np2ntp_id, :user_id
end
