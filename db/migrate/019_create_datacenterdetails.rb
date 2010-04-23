class CreateDatacenterdetails < ActiveRecord::Migration
  def self.up
    create_table :datacenterdetails do |t|
      t.integer :networkterminationpoint_id, :market_id, :qualitytype_id, :sprinklertype_id
      t.integer :occupancy_rate, :age, :parking_spots, :power_grids, :hv_lines, :transformers, :transformers_plus
      t.integer :ups_capacity_plus, :ups_capacity_multiplier, :ups_time_full_load, :ups_system_type_id, :generator_capacity_multiplier
      t.integer :backup_generators, :primary_generators, :diesel_fuel_time, :humidity_control, :humidity_control_plus_minus
      t.integer :raised_floor, :diverse_fibre_entry_multiplier, :secure_telco_room_multiplier
      t.decimal :gross_floor_capacity_metric, :gross_floor_capacity_british, :floor_capacity_metric, :floor_capacity_british
      t.decimal :distance_to_bus_metric, :distance_to_bus_british, :distance_to_train_metric, :distance_to_train_british
      t.decimal :power_density_metric, :power_density_british, :mains_power_supply, :diesel_storage_metric, :diesel_storage_british
      t.decimal :temp_control_metric, :temp_control_british, :temp_control_plus_minus_metric, :temp_control_plus_minus_british
      t.decimal :water_capacity_metric, :water_capacity_british
      t.string :ups_capacity, :generator_brand, :generator_capacity, :crac_units, :crac_type, :cooling_towers_plus
      t.string :fire_rating
      t.string :customer_work_area, :conference_rooms, :site_deliveries, :staging_rooms, :no_cardboard, :full_time_security_personnel, :after_hours_access, {:size => 1}
      t.string :cctv_inside, :cctv_outside, :cctv_tape_storage, :bio_metrics, :man_trap, :cust_sign_in, :cust_proximity_card, {:size => 1}
      t.string :cust_pin_num, :rack_key_access, :cust_access_telco_rm, :security_integrated_bms, :fuel_supplier_contracts, :power_integrated_bms, {:size => 1}
      t.string :anti_static_tiles, :hvac_integrated_bms, :water_chillers, :water_storage_tank, :cooling_towers, :hot_cold_aisle, {:size => 1}
      t.string :fire_suppression, :fire_detection, :fire_extinguishers, :fire_integrated_bms, :smart_hands, :tape_backup, {:size => 1}
      t.string :fire_integrated_bms, :carrier_neutral, :diverse_fibre_entry, :secure_telco_room, :mlpa_platform, :roof_space_available, {:size => 1}
      t.string :coax_x_connect, :utp_x_connect, :fibre_x_connect, :data_power_segmentation, :full_time_noc, :full_time_locally_staffed, {:size => 1}
      t.timestamps
    end
  end

  def self.down
    drop_table :datacenterdetails
  end
end
