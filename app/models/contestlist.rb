class Contestlist < ActiveRecord::Base
  has_many :contest_items, :class_name => 'Contestlistitem', :dependent => :destroy

  def contains_user(user)
    return false if contest_items == nil
    user = user.id if user.instance_of?(User)
    contest_items.each do |contest_item|
      return true if contest_item.user_id = user
    end
    return false
  end 
  
  def parent_id
    obj = eval("#{self.table_name}.find(:first,:conditions => [\"#{self.field_name} = '#{self.id}'\"])")
    return obj.id
  end
  
  def count
    return 0 if self.contest_items == nil
    return contest_items.size
  end
  
  def user_list
    return '(none)' if self.contest_items == nil
    return (self.contest_items.collect {|contest_item| contest_item.user.print_name }).join(',')
  end
  
  def contest_list_name
    obj = eval("#{self.table_name}.find(:first,:conditions => [\"#{self.field_name} = '#{self.id}'\"])")
    label = Tablelabel.find(:first,:conditions => ["table_name = :table", {:table => self.table_name}])
    return eval("obj.#{label.look_up_field}")
  end
end
