class Tablelabel < ActiveRecord::Base
  
  def title(id)
    return '' if self.look_up_field == nil
    obj = eval("#{self.table_name}.find_by_id(#{id})")
    return "" if obj == nil
    begin
      return eval("obj.#{self.look_up_field}")
    rescue
      return ""
    end
  end
end
