class Userlist < ActiveRecord::Base
  has_many :useritems, :class_name => 'Userlistitem', :dependent => :destroy
  has_many :users, :through => :userlistitems
  
  def contains_user(user)
    return false if useritems == nil
    user = user.id if user.instance_of?(User)
    useritems.each do |useritem|
      return true if useritem.user_id = user
    end
    return false
  end 
  
  def parent_id
    obj = eval("#{self.table_name}.find(:first,:conditions => [\"#{self.field_name} = '#{self.id}'\"])")
    return obj.id
  end
end
