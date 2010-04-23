class Np2poi < ActiveRecord::Base
  belongs_to :networkprovider
  belongs_to :poi, :class_name => 'Pointsofinterest'
  belongs_to :connectiontype
  belongs_to :user
  belongs_to :contesting_user_list, :class_name => 'Userlist', :foreign_key => 'contestingUserList'
  
  validates_presence_of :pointofinterest_id, :networkprovider_id
  validates_uniqueness_of :pointofinterest_id, :networkprovider_id
end