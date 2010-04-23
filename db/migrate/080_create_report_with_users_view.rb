class CreateReportWithUsersView < ActiveRecord::Migration
  def self.up
    puts "***create the view in the database with the sql script found in the comments of this migration.***"
=begin
  The following SQL needs to be run inorder to create the reports_with_users view:
CREATE
    /*[ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
    [DEFINER = { user | CURRENT_USER }]
    [SQL SECURITY { DEFINER | INVOKER }]*/
    VIEW `reports_with_users` 
    AS
  select `r`.`id` AS `id`,
  `u1`.`id` AS user_id,
  concat(`u1`.`first_name`,_latin1' ',`u1`.`last_name`) AS `viewer`,
  `r`.`report_title` AS `report_title`,
  `r`.`notes` AS `notes`,
  `rt`.`type_title` AS `type_title`,
  concat(`u1`.`first_name`,_latin1' ',`u1`.`last_name`) AS `owner`,
  (select group_concat(concat(`u2`.`first_name`,_latin1' ',`u2`.`last_name`) separator ', ') AS `print_name` from (`users` `u2` join `sharedreports` `s`) where ((`s`.`report_id` = `r`.`id`) and (`u2`.`id` = `s`.`user_id`))) AS `shared_with`
  from ((`users` `u1` join `reports` `r`) join `reporttypes` `rt`) 
  where ((`r`.`user_id` = `u1`.`id`) and (`r`.`reporttype_id` = `rt`.`id`))
union
  select `r`.`id` AS `id`,
  `u3`.`id` AS user_id,
  concat(`u3`.`first_name`,_latin1' ',`u3`.`last_name`) AS `viewer`,
  `r`.`report_title` AS `report_title`,
  `r`.`notes` AS `notes`,
  `rt`.`type_title` AS `type_title`,
  concat(`u1`.`first_name`,_latin1' ',`u1`.`last_name`) AS `owner`,
  (select group_concat(concat(`u2`.`first_name`,_latin1' ',`u2`.`last_name`) separator ', ') AS `print_name` from (`users` `u2` join `sharedreports` `s`) where ((`s`.`report_id` = `r`.`id`) and (`u2`.`id` = `s`.`user_id`))) AS `shared_with`
  from ((((`users` `u3` join `sharedreports` `sr`) join `reports` `r`) join `users` `u1`) join `reporttypes` `rt`) 
  where ((`sr`.`user_id` = `u3`.`id`) and (`sr`.`report_id` = `r`.`id`) and (`r`.`user_id` = `u1`.`id`) and (`r`.`reporttype_id` = `rt`.`id`));
=end
  end
  
  def self.down
    execute "drop view reports_with_users"
  end
end
