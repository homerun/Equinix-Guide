class Tablefieldlabel < ActiveRecord::Base
  
  def translate_value?
    return false if self.look_up_table == nil or self.look_up_field == nil
    return true
  end
  
  def translate_value(id)
    return '' if self.look_up_table == nil or self.look_up_field == nil
    if self.look_up_table == "Hash" then 
      the_hash = eval("#{self.look_up_field}")
      return the_hash[id]
    else
      the_obj = eval("#{self.look_up_table}.find_by_id(#{id})")
      return '' if the_obj == nil
      return eval("the_obj.#{self.look_up_field}")
    end
  end
end
