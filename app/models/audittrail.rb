class Audittrail < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :field_name, :action#, :table_id, :table_name
  
  
  def create_new_audit(user, table, table_id)
    obj = eval(table).find(table_id)
    eval(table).columns.each do |col|
      unless obj.send(col.name).blank? || col.name == 'created_at' || col.name == 'updated_at'
        audit = Audittrail.new
        audit.user_id = user.id
        audit.table_name = "#{table}"
        audit.table_id = table_id
        audit.transaction_id = 1
        audit.field_name = col.name
        audit.action = 'C'
        audit.new_value = obj.send(col.name)
        audit.save!
      end
    end
  end
  
  def create_update_audit(user, table, table_id, changes = nil)
    obj = eval(table).find(table_id)
    transactionMax = Audittrail.maximum(:transaction_id, :conditions => "table_name = '#{table}' and table_id = #{table_id}")
    transactionMax = 0 if transactionMax.nil?
    if changes.nil? then
      eval(table).columns.each do |col|
        unless col.name == 'created_at' || col.name == 'updated_at'
          last_audit = Audittrail.find(:first, :conditions => "table_name = '#{table}' and table_id = #{table_id} and field_name = '#{col.name}'", :order => "created_at DESC" )
          audit = Audittrail.new
          audit.user_id = user.id
          audit.table_name = "#{table}"
          audit.table_id = table_id
          audit.transaction_id = transactionMax + 1
          audit.field_name = col.name
          audit.action = 'U'
          audit.old_value = last_audit.new_value if last_audit 
          if obj.send(col.name).blank?
            audit.new_value = nil
          else  
            audit.new_value = obj.send(col.name)
          end  
          audit.save! unless "#{audit.old_value}" == "#{audit.new_value}"
        end
      end
    else
      changes.each do |change|
        audit = Audittrail.new
        audit.user_id = user.id
        audit.table_name = "#{table}"
        audit.table_id = table_id
        audit.transaction_id = transactionMax + 1
        audit.field_name = change[:field_name]
        audit.action = 'U'
        audit.old_value = change[:old_value]
        audit.new_value = change[:new_value]
        audit.save!
      end
    end
  end
  
  def create_destroy_audit(user, table, table_id)
    transactionMax = Audittrail.maximum(:transaction_id, :conditions => "table_name = '#{table}' and table_id = #{table_id}")
    transactionMax = 0 if transactionMax.nil?
    eval(table).columns.each do |col|
     unless col.name == 'created_at' || col.name == 'updated_at'  
      last_audit = Audittrail.find(:first, :conditions => "table_name = '#{table}' and table_id = #{table_id} and field_name = '#{col.name}'", :order => "created_at DESC" )
      audit = Audittrail.new
      audit.user_id = user.id
      audit.table_name = "#{table}"
      audit.table_id = self.id
      audit.transaction_id = transactionMax + 1
      audit.field_name = col.name
      audit.action = 'D'
      audit.old_value = last_audit.new_value if last_audit 
      audit.new_value = nil
      audit.save!
     end  
    end
  end

end
