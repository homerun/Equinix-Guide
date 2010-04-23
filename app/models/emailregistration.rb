class Emailregistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :operating_user, :class_name => 'User', :foreign_key => 'operating_user_id'
  
  validates_presence_of :user_id, :expiration_date, :email_id
end
