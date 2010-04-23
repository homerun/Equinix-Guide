class AddRemoveNewConnectionType < ActiveRecord::Migration
  
  def self.up
    if Connectiontype.find_by_type_description('******NEW******').nil? then
      new_connection_type = Connectiontype.new
      new_connection_type.name = 'X'
      new_connection_type.type_description = "******NEW******"
      new_connection_type.save!
    end
  end

  def self.down 
    new_connection_type = Connectiontype.find_by_type_description("******NEW******")
    new_connection_type.destroy unless new_connection_type.nil?
  end

end