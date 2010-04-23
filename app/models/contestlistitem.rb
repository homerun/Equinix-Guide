class Contestlistitem < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest_list, :class_name => 'Contestlist'
  belongs_to :connectiontype

  validates_presence_of :user_id, :contestlist_id

  def connection_type
    return eval("#{contest_list.connectionTable}.find(:first,:conditions => [\"id = '#{self.connectiontype_id}'\"])")
  end  

end
