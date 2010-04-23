class CreateUserViewInDB < ActiveRecord::Migration
  def self.up
    sql_to_exec = ''
    sql_to_exec += "CREATE VIEW `users_with_poi_associations` AS\n"
    sql_to_exec += "SELECT user_id, group_concat(poi.`name` separator ', ') AS `associations` FROM user_pois u_poi, pointsofinterests poi\n"
    sql_to_exec += "WHERE u_poi.pointsofinterest_id = poi.id\n"
    sql_to_exec += "group by user_id;\n"
    execute sql_to_exec
    
    sql_to_exec = ''
    sql_to_exec += "CREATE VIEW `users_with_ntp_o_associations` AS\n"
    sql_to_exec += "SELECT user_id, group_concat(ntp_o.`name` separator ', ') AS `associations` FROM user_ntp_owners u_ntp_o, networktermptowners ntp_o\n"
    sql_to_exec += "WHERE u_ntp_o.networktermptowner_id = ntp_o.id\n"
    sql_to_exec += "group by user_id;\n"
    execute sql_to_exec
    
    sql_to_exec = ''
    sql_to_exec += "CREATE VIEW `users_with_np_associations` AS\n"
    sql_to_exec += "SELECT user_id, group_concat(np.`name` separator ', ') AS `associations` FROM user_nps u_np, networkproviders np\n"
    sql_to_exec += "WHERE u_np.networkprovider_id = np.id\n"
    sql_to_exec += "group by user_id;\n"
    execute sql_to_exec
    
    sql_to_exec = ''
    sql_to_exec += "CREATE VIEW `users_with_associations` AS\n"
    sql_to_exec += "SELECT distinct u.id AS `id`,\n"
    sql_to_exec += "  `u`.`first_name` AS first_name,\n"
    sql_to_exec += "  `u`.`last_name` AS `last_name`,\n"
    sql_to_exec += "  u.email AS email,\n"
    sql_to_exec += "  np_a.associations AS np_associations,\n"
    sql_to_exec += "  poi_a.associations AS poi_associations,\n"
    sql_to_exec += "  ntp_o_a.associations AS ntp_o_associations,\n"
    sql_to_exec += "  r.name AS role_name,\n"
    sql_to_exec += "  case when u.active = 'D' or u.active = 'N' then 'Deleted'\n"
    sql_to_exec += "  when u.role_id = 5 or u.role_id is null then 'N/A'\n"
    sql_to_exec += "  when u.active = 'R' then 'Unregistered'\n"
    sql_to_exec += "  else 'Active' end AS `status`\n"
    sql_to_exec += "FROM users u \n"
    sql_to_exec += "LEFT JOIN roles r ON r.id = u.role_id\n"
    sql_to_exec += "LEFT JOIN users_with_np_associations np_a ON u.id = np_a.user_id\n"
    sql_to_exec += "LEFT JOIN users_with_poi_associations poi_a ON u.id = poi_a.user_id\n"
    sql_to_exec += "LEFT JOIN users_with_ntp_o_associations ntp_o_a ON u.id = ntp_o_a.user_id;\n"
    execute sql_to_exec
    
    role = Role.new()
    role.name = "Contact"
    role.description = "No access to anything but inquiry response pages."
    role.id = 5
    role.save
    
  end
  
  def self.down
    execute "drop view `users_with_associations`"
    execute "drop view `users_with_np_associations`"
    execute "drop view `users_with_poi_associations`"
    execute "drop view `users_with_ntp_o_associations`"
    
    role = Role.find_by_id(5)
    role.destroy unless role.nil?
  end
end