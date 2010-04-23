class CreateTablefieldlabels < ActiveRecord::Migration
  def self.up
    create_table :tablefieldlabels do |t|
      t.string :table_name, :field_name, :label, :look_up_table, :look_up_field
      t.text :description
      t.timestamps
    end
    
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Campus"
    tablefieldlabel.field_name = "networktermptowner_id"
    tablefieldlabel.description = "Network Termination Point Owner associated with the Campus"
    tablefieldlabel.label = "Network Termination Point Owner"
    tablefieldlabel.look_up_table = "Networktermptowner"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Campus"
    tablefieldlabel.field_name = "name"
    tablefieldlabel.description = "Name of the Campus"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Campus"
    tablefieldlabel.field_name = "url"
    tablefieldlabel.description = "URL"
    tablefieldlabel.label = "URL"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Campus"
    tablefieldlabel.field_name = "userContact"
    tablefieldlabel.description = "Contact for the Campus"
    tablefieldlabel.label = "Contact"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "networkterminationpoint_id"
    tablefieldlabel.description = "Network Termination Point Association"
    tablefieldlabel.label = "Network Termination Point"
    tablefieldlabel.look_up_table = "Networkterminationpoint"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "gross_floor_capacity_metric"
    tablefieldlabel.description = "Total Floor Capacity Offices included"
    tablefieldlabel.label = "Gross Floor Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "gross_floor_capacity_british"
    tablefieldlabel.description = "Total Floor Capacity Offices included"
    tablefieldlabel.label = "Gross Floor Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "floor_capacity_metric"
    tablefieldlabel.description = "Available Floor Capacity"
    tablefieldlabel.label = "Floor Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "floor_capacity_british"
    tablefieldlabel.description = "Available Floor Capacity"
    tablefieldlabel.label = "Floor Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "occupancy_rate"
    tablefieldlabel.description = "Occupancy Rate of Floor Capacity"
    tablefieldlabel.label = "Occupancy Rate"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "qualitytype_id"
    tablefieldlabel.description = "Quality Type"
    tablefieldlabel.label = "Quality Type"
    tablefieldlabel.look_up_table = "Qualitytype"
    tablefieldlabel.look_up_field = "quality_type"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "age"
    tablefieldlabel.description = "Age of Facility in years"
    tablefieldlabel.label = "Age of Facility"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "customer_work_area"
    tablefieldlabel.description = "Customer Work Area"
    tablefieldlabel.label = "Customer Work Area"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "conference_rooms"
    tablefieldlabel.description = "Conference Rooms"
    tablefieldlabel.label = "Conference Rooms"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "site_deliveries"
    tablefieldlabel.description = "Site Deliveries"
    tablefieldlabel.label = "Site Deliveries"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "staging_rooms"
    tablefieldlabel.description = "Staging Rooms"
    tablefieldlabel.label = "Staging Rooms"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "no_cardboard"
    tablefieldlabel.description = "No Cardboard"
    tablefieldlabel.label = "No Cardboard"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "distance_to_bus_metric"
    tablefieldlabel.description = "Distance To Bus"
    tablefieldlabel.label = "Distance To Bus"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "distance_to_bus_british"
    tablefieldlabel.description = "Distance To Bus"
    tablefieldlabel.label = "Distance To Bus"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "distance_to_train_metric"
    tablefieldlabel.description = "Distance To Train"
    tablefieldlabel.label = "Distance To Train"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "distance_to_train_british"
    tablefieldlabel.description = "Distance To Train"
    tablefieldlabel.label = "Distance To Train"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "parking_spots"
    tablefieldlabel.description = "Parking Spots"
    tablefieldlabel.label = "Parking Spots"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "full_time_security_personnel"
    tablefieldlabel.description = "Full Time Security Personnel"
    tablefieldlabel.label = "Full Time Security Personnel"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "after_hours_access"
    tablefieldlabel.description = "After Hours Access"
    tablefieldlabel.label = "After Hours Access"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cctv_inside"
    tablefieldlabel.description = "CCTV Inside"
    tablefieldlabel.label = "CCTV Inside"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cctv_outside"
    tablefieldlabel.description = "CCTV Outside"
    tablefieldlabel.label = "CCTV Outside"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cctv_tape_storage"
    tablefieldlabel.description = "CCTV Tape Storage"
    tablefieldlabel.label = "CCTV Tape Storage"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "bio_metrics"
    tablefieldlabel.description = "Bio Metrics"
    tablefieldlabel.label = "Bio Metrics"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "man_trap"
    tablefieldlabel.description = "Man Trap"
    tablefieldlabel.label = "Man Trap"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cust_sign_in"
    tablefieldlabel.description = "Customer Sign In"
    tablefieldlabel.label = "Customer Sign In"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cust_proximity_card"
    tablefieldlabel.description = "Customer Proximity Card"
    tablefieldlabel.label = "Customer Proximity Card"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\', \'P\' => \'Provided @ sign in\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cust_pin_num"
    tablefieldlabel.description = "Customer Pin Number"
    tablefieldlabel.label = "Customer Pin Number"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "rack_key_access"
    tablefieldlabel.description = "Rack Key Access"
    tablefieldlabel.label = "Rack Key Access"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'N\' => \'Onsite\', \'F\' => \'Offsite\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cust_access_telco_rm"
    tablefieldlabel.description = "Customer Access Telco Rooms"
    tablefieldlabel.label = "Customer Access Telco Rooms"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "security_integrated_bms"
    tablefieldlabel.description = "Security Integrated BMS"
    tablefieldlabel.label = "Security Integrated BMS"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "power_density_metric"
    tablefieldlabel.description = "Power Density"
    tablefieldlabel.label = "Power Density"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "power_density_british"
    tablefieldlabel.description = "Power Density"
    tablefieldlabel.label = "Power Density"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "power_grids"
    tablefieldlabel.description = "Power Grids"
    tablefieldlabel.label = "Power Grids"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "mains_power_supply"
    tablefieldlabel.description = "Mains Power Supply"
    tablefieldlabel.label = "Mains Power Supply"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "hv_lines"
    tablefieldlabel.description = "HV Lines"
    tablefieldlabel.label = "HV Lines"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "transformers"
    tablefieldlabel.description = "Transformers"
    tablefieldlabel.label = "Transformers"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "transformers_plus"
    tablefieldlabel.description = "Additional Transformers"
    tablefieldlabel.label = "Additional Transformers"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "ups_system_type_id"
    tablefieldlabel.description = "UPS System Type"
    tablefieldlabel.label = "UPS System Type"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "ups_capacity"
    tablefieldlabel.description = "UPS Capacity"
    tablefieldlabel.label = "UPS Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "ups_capacity_plus"
    tablefieldlabel.description = "Additional UPS Capacity"
    tablefieldlabel.label = "Additional UPS Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "ups_capacity_multiplier"
    tablefieldlabel.description = "Number of UPS Storage Units"
    tablefieldlabel.label = "# of UPS Storage Units"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "ups_full_time_load"
    tablefieldlabel.description = "UPS Full Time Load"
    tablefieldlabel.label = "UPS Full Time Load"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "generator_brand"
    tablefieldlabel.description = "Generator Brand"
    tablefieldlabel.label = "Generator Brand"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "generator_capacity"
    tablefieldlabel.description = "Generator Capacity"
    tablefieldlabel.label = "Generator Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "generator_capacity_multiplier"
    tablefieldlabel.description = "Number of Generators"
    tablefieldlabel.label = "Number of Generators"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "backup_generators"
    tablefieldlabel.description = "Number of Backup Generators"
    tablefieldlabel.label = "Backup Generators"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "primary_generators"
    tablefieldlabel.description = "Number of Primary Generators"
    tablefieldlabel.label = "Primary Generators"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "diesel_storage_metric"
    tablefieldlabel.description = "Diesel Storage"
    tablefieldlabel.label = "Diesel Storage"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "diesel_storage_british"
    tablefieldlabel.description = "Diesel Storage"
    tablefieldlabel.label = "Diesel Storage"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "diesel_fuel_time"
    tablefieldlabel.description = "Diesel Fuel Time"
    tablefieldlabel.label = "Diesel Fuel Time"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fuel_supplier_contracts"
    tablefieldlabel.description = "Fuel Supplier Contracts"
    tablefieldlabel.label = "Fuel Supplier Contracts"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "power_integrated_bms"
    tablefieldlabel.description = "Power Integrated BMS"
    tablefieldlabel.label = "Power Integrated BMS"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "temp_control_metric"
    tablefieldlabel.description = "Temperature Control"
    tablefieldlabel.label = "Temperature Control"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "temp_control_british"
    tablefieldlabel.description = "Temperature Control"
    tablefieldlabel.label = "Temperature Control"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "temp_control_plus_minus_metric"
    tablefieldlabel.description = "Temperature Control Variance"
    tablefieldlabel.label = "Temperature Control Variance"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "temp_control_plus_minus_british"
    tablefieldlabel.description = "Temperature Control Variance"
    tablefieldlabel.label = "Temperature Control Variance"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "humidity_control"
    tablefieldlabel.description = "Humidity Control"
    tablefieldlabel.label = "Humidity Control"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "humidity_control_plus_minus"
    tablefieldlabel.description = "Humidity Control Variance"
    tablefieldlabel.label = "Humidity Control Variance"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "raised_floor"
    tablefieldlabel.description = "Raised Floor"
    tablefieldlabel.label = "Raised Floor"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "anti_static_tiles"
    tablefieldlabel.description = "Anti-static Tiles"
    tablefieldlabel.label = "Anti-static Tiles"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "crac_units"
    tablefieldlabel.description = "CRAC Units"
    tablefieldlabel.label = "CRAC Units"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "crac_type"
    tablefieldlabel.description = "CRAC Type"
    tablefieldlabel.label = "CRAC Type"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "hvac_integrated_bms"
    tablefieldlabel.description = "HVAC Integrated BMS"
    tablefieldlabel.label = "HVAC Integrated BMS"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "water_chillers"
    tablefieldlabel.description = "Water Chillers"
    tablefieldlabel.label = "Water Chillers"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "water_storage_tank"
    tablefieldlabel.description = "Water Storage Tank"
    tablefieldlabel.label = "Water Storage Tank"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "water_capacity_metric"
    tablefieldlabel.description = "Water Storage Capacity"
    tablefieldlabel.label = "Water Storage Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "water_capacity_british"
    tablefieldlabel.description = "Water Storage Capacity"
    tablefieldlabel.label = "Water Storage Capacity"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cooling_towers"
    tablefieldlabel.description = "Cooling Towers"
    tablefieldlabel.label = "Cooling Towers"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "cooling_towers_plus"
    tablefieldlabel.description = "Additional Cooling Towers"
    tablefieldlabel.label = "Additional Cooling Towers"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "hot_cold_aisle"
    tablefieldlabel.description = "Hot/Cold Aisle"
    tablefieldlabel.label = "Hot/Cold Aisle"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fire_suppression"
    tablefieldlabel.description = "Fire Suppression"
    tablefieldlabel.label = "Fire Suppression"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fire_detection"
    tablefieldlabel.description = "Fire Detection"
    tablefieldlabel.label = "Fire Detection"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fire_integrated_bms"
    tablefieldlabel.description = "Fire Integrated BMS"
    tablefieldlabel.label = "Fire Integrated BMS"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "sprinklertype_id"
    tablefieldlabel.description = "Sprinkler Type"
    tablefieldlabel.label = "Sprinkler Type"
    tablefieldlabel.look_up_table = "Sprinklertype"
    tablefieldlabel.look_up_field = "sprinkler_type"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fire_extinguishers"
    tablefieldlabel.description = "Fire Extinguishers"
    tablefieldlabel.label = "Fire Extinguishers"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fire_rating"
    tablefieldlabel.description = "Fire Rating"
    tablefieldlabel.label = "Fire Rating"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "smart_hands"
    tablefieldlabel.description = "Smart Hands"
    tablefieldlabel.label = "Smart Hands"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "tape_backup"
    tablefieldlabel.description = "Tape Backup"
    tablefieldlabel.label = "Tape Backup"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "carrier_neutral"
    tablefieldlabel.description = "Carrier Neutral"
    tablefieldlabel.label = "Carrier Neutral"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "diverse_fibre_entry"
    tablefieldlabel.description = "Diverse Fibre Entry"
    tablefieldlabel.label = "Diverse Fibre Entry"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "diverse_fibre_entry_multiplier"
    tablefieldlabel.description = "Diverse Fibre Entry Multiplier"
    tablefieldlabel.label = "Diverse Fibre Entry Multiplier"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "secure_telco_room"
    tablefieldlabel.description = "Secure Telco Room"
    tablefieldlabel.label = "Secure Telco Room"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "secure_telco_room_multiplier"
    tablefieldlabel.description = "Secure Telco Room Multiplier"
    tablefieldlabel.label = "Secure Telco Room Multiplier"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "mlpa_platform"
    tablefieldlabel.description = "MLPA Platform"
    tablefieldlabel.label = "MLPA Platform"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "coax_x_connect"
    tablefieldlabel.description = "COAX X-Connect"
    tablefieldlabel.label = "COAX X-Connect"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "utp_x_connect"
    tablefieldlabel.description = "UTP X-Connect"
    tablefieldlabel.label = "UTP X-Connect"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "fibre_x_connect"
    tablefieldlabel.description = "Fibre X-Connect"
    tablefieldlabel.label = "Fibre X-Connect"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "data_power_segmentation"
    tablefieldlabel.description = "Data Power Segmentation"
    tablefieldlabel.label = "Data Power Segmentation"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "full_time_noc"
    tablefieldlabel.description = "Full Time NOC"
    tablefieldlabel.label = "Full Time NOC"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "full_time_locally_staffed"
    tablefieldlabel.description = "Full Time Locally Staffed"
    tablefieldlabel.label = "Full Time Locally Staffed"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Datacenterdetail"
    tablefieldlabel.field_name = "roof_space_available"
    tablefieldlabel.description = "Roof Space Available"
    tablefieldlabel.label = "Roof Space Available"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Equinixregion"
    tablefieldlabel.field_name = "region_name"
    tablefieldlabel.description = "Region Name"
    tablefieldlabel.label = "Region Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = ""
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Latencytime"
    tablefieldlabel.field_name = "a_np2ntp_id"
    tablefieldlabel.description = "Network Termination Point A"
    tablefieldlabel.label = "Network Termination Point A"
    tablefieldlabel.look_up_table = "Networkterminationpoint"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Latencytime"
    tablefieldlabel.field_name = "b_np2ntp_id"
    tablefieldlabel.description = "Network Termination Point B"
    tablefieldlabel.label = "Network Termination Point B"
    tablefieldlabel.look_up_table = "Networkterminationpoint"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Latencytime"
    tablefieldlabel.field_name = "latencyTime"
    tablefieldlabel.description = "Latency Time"
    tablefieldlabel.label = "Latency Time"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Latencytime"
    tablefieldlabel.field_name = "userCertified"
    tablefieldlabel.description = "Certified By User"
    tablefieldlabel.label = "Certified By User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Latencytime"
    tablefieldlabel.field_name = "certifiedDate"
    tablefieldlabel.description = "Certified Date"
    tablefieldlabel.label = "Certified Date"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Latencytime"
    tablefieldlabel.field_name = "contestList"
    tablefieldlabel.description = "Contested By Users"
    tablefieldlabel.label = "Contested By Users"
    tablefieldlabel.look_up_table = "Contestlist"
    tablefieldlabel.look_up_field = "user_list"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Market"
    tablefieldlabel.field_name = "country_id"
    tablefieldlabel.description = "Country"
    tablefieldlabel.label = "Country"
    tablefieldlabel.look_up_table = "Country"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Market"
    tablefieldlabel.field_name = "market_name"
    tablefieldlabel.description = "Name"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Market"
    tablefieldlabel.field_name = "market_description"
    tablefieldlabel.description = "Description of the Market"
    tablefieldlabel.label = "Market Description"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "name"
    tablefieldlabel.description = "Name of the Network Provider"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "url"
    tablefieldlabel.description = "URL"
    tablefieldlabel.label = "URL"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "ASN"
    tablefieldlabel.description = "ASN"
    tablefieldlabel.label = "ASN"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "user_contact_region1"
    tablefieldlabel.description = "Contact for United States Region"
    tablefieldlabel.label = "United States Contact"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "user_contact_region2"
    tablefieldlabel.description = "Contact for Asia Pacific Region"
    tablefieldlabel.label = "Asia Pacific Contact"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "user_contact_region3"
    tablefieldlabel.description = "Contact for Europe Region"
    tablefieldlabel.label = "Europe Contact"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "user_contact_region4"
    tablefieldlabel.description = "Contact for Other Region"
    tablefieldlabel.label = "Other Region Contact"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkprovider"
    tablefieldlabel.field_name = "np_type"
    tablefieldlabel.description = "Network Provider Type"
    tablefieldlabel.label = "Network Provider Type"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'E\' => \'Extranet\', \'C\' => \'Carrier\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "name"
    tablefieldlabel.description = "Name of Network Termination Point"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "street_address"
    tablefieldlabel.description = "Street Address"
    tablefieldlabel.label = "Address"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "floor"
    tablefieldlabel.description = "Floor"
    tablefieldlabel.label = "Floor"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "suite"
    tablefieldlabel.description = "Suite"
    tablefieldlabel.label = "Suite"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "city"
    tablefieldlabel.description = "City"
    tablefieldlabel.label = "City"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "state_or_province"
    tablefieldlabel.description = "State or Province"
    tablefieldlabel.label = "State or Province"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "zip_code"
    tablefieldlabel.description = "Zip Code"
    tablefieldlabel.label = "Zip Code"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "country_id"
    tablefieldlabel.description = "Country"
    tablefieldlabel.label = "Country"
    tablefieldlabel.look_up_table = "Country"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "lat"
    tablefieldlabel.description = "Latitude"
    tablefieldlabel.label = "Latitude"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "lon"
    tablefieldlabel.description = "Longitude"
    tablefieldlabel.label = "Longitude"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "coordinates_exact"
    tablefieldlabel.description = "Network Termination Point Has Exact Coordinates"
    tablefieldlabel.label = "Exact Coordinates"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "npa_nxx"
    tablefieldlabel.description = "NPA-NXX"
    tablefieldlabel.label = "NPA-NXX"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "campus_id"
    tablefieldlabel.description = "Campus"
    tablefieldlabel.label = "Campus"
    tablefieldlabel.look_up_table = "Campus"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "networktermpttype_id"
    tablefieldlabel.description = "Network Termination Point Type"
    tablefieldlabel.label = "Network Termination Point Type"
    tablefieldlabel.look_up_table = "Networktermpttype"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networkterminationpoint"
    tablefieldlabel.field_name = "networktermptowner_id"
    tablefieldlabel.description = "Network Termination Point Owner"
    tablefieldlabel.label = "Network Termination Point Owner"
    tablefieldlabel.look_up_table = "Networktermptowner"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Networktermptowner"
    tablefieldlabel.field_name = "name"
    tablefieldlabel.description = "Name of Network Termination Point Owner"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "networkterminationpoint_id"
    tablefieldlabel.description = "Network Termination Point"
    tablefieldlabel.label = "Network Termination Point"
    tablefieldlabel.look_up_table = "Networkterminationpoint"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "networkprovider_id"
    tablefieldlabel.description = "Network Provider"
    tablefieldlabel.label = "Network Provider"
    tablefieldlabel.look_up_table = "Networkprovider"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "connectiontype_id"
    tablefieldlabel.description = "Connection Type"
    tablefieldlabel.label = "Connection Type"
    tablefieldlabel.look_up_table = "Connectiontype"
    tablefieldlabel.look_up_field = "type_description"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "userCertified"
    tablefieldlabel.description = "Certified By User"
    tablefieldlabel.label = "Certified By User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "certifiedDate"
    tablefieldlabel.description = "Certified Date"
    tablefieldlabel.label = "Certified Date"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Np2ntp"
    tablefieldlabel.field_name = "contestList"
    tablefieldlabel.description = "Contested By Users"
    tablefieldlabel.label = "Contested By Users"
    tablefieldlabel.look_up_table = "Contestlist"
    tablefieldlabel.look_up_field = "user_list"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "networkterminationpoint_id"
    tablefieldlabel.description = "Network Termination Point"
    tablefieldlabel.label = "Network Termination Point"
    tablefieldlabel.look_up_table = "Networkterminationpoint"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "pointsofinterest_id"
    tablefieldlabel.description = "Point of Interest"
    tablefieldlabel.label = "Point of Interest"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "poiconnectiontype_id" 
    tablefieldlabel.description = "Connection Type"
    tablefieldlabel.label = "Connection Type"
    tablefieldlabel.look_up_table = "Poiconnectiontype"
    tablefieldlabel.look_up_field = "description"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "userCertified"
    tablefieldlabel.description = "Certified By User"
    tablefieldlabel.label = "Certified By User"
    tablefieldlabel.look_up_table = "User"
    tablefieldlabel.look_up_field = "print_name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "certifiedDate"
    tablefieldlabel.description = "Certified Date"
    tablefieldlabel.label = "Certified Date"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poi2ntp"
    tablefieldlabel.field_name = "contestList"
    tablefieldlabel.description = "Contested By Users"
    tablefieldlabel.label = "Contested By Users"
    tablefieldlabel.look_up_table = "Contestlist"
    tablefieldlabel.look_up_field = "user_list"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "name"
    tablefieldlabel.description = "Name of Point of Interest"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "abbreviation"
    tablefieldlabel.description = "Abbreviation"
    tablefieldlabel.label = "Abbreviation"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "url"
    tablefieldlabel.description = "URL"
    tablefieldlabel.label = "URL"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "notes"
    tablefieldlabel.description = "Notes"
    tablefieldlabel.label = "Notes"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "equities_class"
    tablefieldlabel.description = "Equities Class"
    tablefieldlabel.label = "Equities Class"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "fixed_income_class"
    tablefieldlabel.description = "Fixed Income Class"
    tablefieldlabel.label = "Fixed Income Class"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "futures_class"
    tablefieldlabel.description = "Derivatives Class"
    tablefieldlabel.label = "Derivatives Class"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "foreign_exchange_class"
    tablefieldlabel.description = "Foreign Exchange Class"
    tablefieldlabel.label = "Foreign Exchange Class"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'Y\' => \'Yes\', \'N\' => \'No\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "parent_pointsofinterest_id"
    tablefieldlabel.description = "Parent Point of Interest"
    tablefieldlabel.label = "Parent Point of Interest"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "poitype_id"
    tablefieldlabel.description = "Point of Interest Type"
    tablefieldlabel.label = "Point of Interest Type"
    tablefieldlabel.look_up_table = "Poitype"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Pointsofinterest"
    tablefieldlabel.field_name = "unsubregion_id"
    tablefieldlabel.description = "Subregion"
    tablefieldlabel.label = "Subregion"
    tablefieldlabel.look_up_table = "Unsubregion"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poipreferrednp"
    tablefieldlabel.field_name = "pointsofinterest_id"
    tablefieldlabel.description = "Point of Interest"
    tablefieldlabel.label = "Point of Interest"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Poipreferrednp"
    tablefieldlabel.field_name = "networkprovider_id"
    tablefieldlabel.description = "Network Provider"
    tablefieldlabel.label = "Network Provider"
    tablefieldlabel.look_up_table = "Networkprovider"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Service"
    tablefieldlabel.field_name = "pointsofinterest_id"
    tablefieldlabel.description = "Point of Interest"
    tablefieldlabel.label = "Point of Interest"
    tablefieldlabel.look_up_table = "Pointsofinterest"
    tablefieldlabel.look_up_field = "name"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Service"
    tablefieldlabel.field_name = "service_acronym"
    tablefieldlabel.description = "Service Acronym"
    tablefieldlabel.label = "Service Acronym"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Service"
    tablefieldlabel.field_name = "name"
    tablefieldlabel.description = "Name of Service"
    tablefieldlabel.label = "Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Service"
    tablefieldlabel.field_name = "description"
    tablefieldlabel.description = "Description of Service"
    tablefieldlabel.label = "Description"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "first_name"
    tablefieldlabel.description = "First Name"
    tablefieldlabel.label = "First Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "last_name"
    tablefieldlabel.description = "Last Name"
    tablefieldlabel.label = "Last Name"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "email"
    tablefieldlabel.description = "Email Address"
    tablefieldlabel.label = "Email Address"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "phone_number"
    tablefieldlabel.description = "Phone Number"
    tablefieldlabel.label = "Phone Number"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "unit_preference"
    tablefieldlabel.description = "Unit Preference"
    tablefieldlabel.label = "Unit Preference"
    tablefieldlabel.look_up_table = "Hash"
    tablefieldlabel.look_up_field = "{ \'M\' => \'Metric\', \'B\' => \'Imperial\' }"
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "associationTable"
    tablefieldlabel.description = "Association Object"
    tablefieldlabel.label = "Association Object"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "User"
    tablefieldlabel.field_name = "associationTableId"
    tablefieldlabel.description = "Association Object Id"
    tablefieldlabel.label = "Association Object Id"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Newsitem"
    tablefieldlabel.field_name = "title"
    tablefieldlabel.description = "Title"
    tablefieldlabel.label = "Title"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Newsitem"
    tablefieldlabel.field_name = "descr"
    tablefieldlabel.description = "Description"
    tablefieldlabel.label = "Description"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!
        
    tablefieldlabel = Tablefieldlabel.new
    tablefieldlabel.table_name = "Newsitem"
    tablefieldlabel.field_name = "tags"
    tablefieldlabel.description = "Other Tags"
    tablefieldlabel.label = "Free Form Tag"
    tablefieldlabel.look_up_table = nil
    tablefieldlabel.look_up_field = nil
    tablefieldlabel.save!

  end

  def self.down
    drop_table :tablefieldlabels
  end
end
