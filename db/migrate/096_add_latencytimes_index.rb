class AddLatencytimesIndex < ActiveRecord::Migration
  
  def self.up
    add_index :latencytimes, [:a_np2ntp_id, :b_np2ntp_id], :unique => true, :name => 'np2ntp_ids'
    sql_to_execute = ''
    sql_to_execute += "CREATE VIEW equinix_inter_market_latencytimes AS\n"
    sql_to_execute += "select  ntp1.id as a_networkterminationpoint_id,\n"
    sql_to_execute += "dc1.market_id as a_market_id,\n"
    sql_to_execute += "connection1.id as a_np2ntp_id,\n"
    sql_to_execute += "ntp2.id as b_networkterminationpoint_id,\n"
    sql_to_execute += "dc2.market_id as b_market_id,\n"
    sql_to_execute += "connection2.id as b_np2ntp_id,\n"
    sql_to_execute += "lat.id as latencytime_id\n"
    sql_to_execute += "FROM networkterminationpoints ntp1, \n"
    sql_to_execute += "datacenterdetails dc1, \n"
    sql_to_execute += "np2ntps connection1, \n"
    sql_to_execute += "networkterminationpoints ntp2, \n"
    sql_to_execute += "datacenterdetails dc2, \n"
    sql_to_execute += "np2ntps connection2, \n"
    sql_to_execute += "networkproviders np,\n"
    sql_to_execute += "latencytimes lat\n"
    sql_to_execute += "WHERE ntp1.id = dc1.networkterminationpoint_id\n"
    sql_to_execute += "AND ntp1.id = connection1.networkterminationpoint_id\n"
    sql_to_execute += "AND np.id = connection1.networkprovider_id\n"
    sql_to_execute += "AND np.id = connection2.networkprovider_id\n"
    sql_to_execute += "AND ntp2.id = connection2.networkterminationpoint_id\n"
    sql_to_execute += "AND ntp2.id = dc2.networkterminationpoint_id\n"
    sql_to_execute += "AND ntp1.networktermptowner_id = 1\n"
    sql_to_execute += "AND ntp2.networktermptowner_id = 1\n"
    sql_to_execute += "AND dc1.market_id <> dc2.market_id\n"
    sql_to_execute += "AND connection1.id <> connection2.id\n"
    sql_to_execute += "AND lat.a_np2ntp_id = least(connection1.id,connection2.id)\n"
    sql_to_execute += "AND lat.b_np2ntp_id = greatest(connection1.id,connection2.id);\n"
    execute sql_to_execute
  end

  def self.down 
    execute "drop view equinix_inter_market_latencytimes;\n"
    
    remove_index :latencytimes, :name => 'np2ntp_ids'
  end

end