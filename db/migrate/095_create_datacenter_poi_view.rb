class CreateDatacenterPoiView < ActiveRecord::Migration
  def self.up
    sql_to_exec = ''
    sql_to_exec += "CREATE VIEW datacenter_pois AS\n"
    sql_to_exec += "select ntp.id as networkterminationpoint_id, ntp.country_id, dc.market_id, poi2ntps.id as poi2ntp_id, poi2ntps.poiconnectiontype_id, poi.equities_class, poi.fixed_income_class, poi.foreign_exchange_class, poi.futures_class\n"
    sql_to_exec += "from networkterminationpoints ntp, datacenterdetails dc, poi2ntps, pointsofinterests poi\n"
    sql_to_exec += "where ntp.id = dc.networkterminationpoint_id\n"
    sql_to_exec += "and ntp.networktermpttype_id = 1\n"
    sql_to_exec += "and poi2ntps.pointsofinterest_id = poi.id\n"
    sql_to_exec += "and poi2ntps.networkterminationpoint_id = ntp.id\n"
    sql_to_exec += "and poi2ntps.prospectstatustype_id = 1;\n"
    execute sql_to_exec
  end
  
  def self.down
    execute "drop view datacenter_pois"
  end
end