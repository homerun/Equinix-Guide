class CreateNetworkterminationpoints < ActiveRecord::Migration
  def self.up
    create_table :networkterminationpoints do |t|
      t.string :name, :street_address, :floor, :suite, :city, :state_or_province, :zip_code
      t.string :npa_nxx
      t.integer :country_id, :campus_id, :networktermpttype_id, :networktermptowner_id
      t.decimal :lat, :lon, { :precision => 12, :scale => 7 }
      t.boolean :coordinates_exact, :default => false
      t.boolean :is_future_build, :default => false
      t.datetime :future_build_date
      t.timestamps
    end
    
    ntp = Networkterminationpoint.new
    ntp.name = 'Equinix (SY1)'
    ntp.street_address = 'Unit B 639 Gardeners Rd.'
    ntp.city = 'Mascot'
    ntp.state_or_province = 'New South Wales'
    ntp.zip_code = '2020'
    ntp.country_id = Country.find_by_name('Australia')
    ntp.lat = -33.920713
    ntp.lon = 151.188725
    ntp.coordinates_exact = true
    ntp.networktermpttype_id = Networktermpttype.find_by_name('Datacenter').id
    ntp.networktermptowner_id = Networktermptowner.find_by_name('Equinix').id
    ntp.save!
  end

  def self.down
    drop_table :networkterminationpoints
  end
end


