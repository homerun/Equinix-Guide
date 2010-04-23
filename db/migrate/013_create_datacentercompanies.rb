class CreateDatacentercompanies < ActiveRecord::Migration
  def self.up
    create_table :datacentercompanies do |t|
      t.string :company
      t.timestamps
    end
    
    ["Equinix", "Global Switch", "Fujitsu", "Optus Expan", "Telstra", "PowerTel", "Macquarie Telecom Intellicentre", "iPrimus", "Datacom", "Verizon", "Technical Real Estate", "SAVVIS"].each do |c|
      company = Datacentercompany.new
      company.company = c
      company.save!
    end
  end

  def self.down
    drop_table :datacentercompanies
  end
end
