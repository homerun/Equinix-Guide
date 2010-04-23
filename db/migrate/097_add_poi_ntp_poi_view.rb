class AddPoiNtpPoiView < ActiveRecord::Migration
  
  def self.up
    sql_to_execute = ''
    sql_to_execute += "CREATE VIEW poi_ntp_pois AS\n"
    sql_to_execute += "select poi1.id as a_pointsofinterest_id, poi2.id as b_pointsofinterest_id, ntp.id as networkterminationpoint_id\n"
    sql_to_execute += "from pointsofinterests poi1, pointsofinterests poi2, networkterminationpoints ntp, poi2ntps connection1,poi2ntps connection2\n"
    sql_to_execute += "where connection1.pointsofinterest_id = poi1.id\n"
    sql_to_execute += "and connection2.pointsofinterest_id = poi2.id\n"
    sql_to_execute += "and connection1.id <> connection2.id\n"
    sql_to_execute += "and connection1.networkterminationpoint_id = ntp.id\n"
    sql_to_execute += "and connection2.networkterminationpoint_id = ntp.id\n"
    sql_to_execute += "AND connection1.prospectstatustype_id = 1\n"
    sql_to_execute += "AND connection2.prospectstatustype_id = 1;\n"
    execute sql_to_execute
  end
  
  def self.down
    execute "DROP VIEW poi_ntp_pois;\n"
  end
end