class CreateUnsubregions < ActiveRecord::Migration
  def self.up
    create_table :unsubregions do |t|
      t.string :name
      t.integer :equinixregion_id
      t.timestamps
    end
    
    if(Unsubregion.find_by_name("Southern Asia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Southern Asia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Southern Europe").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Southern Europe"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Europe").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Northern Africa").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Northern Africa"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Polynesia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Polynesia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Middle Africa").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Middle Africa"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Caribbean").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Caribbean"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("South America").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "South America"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("United States").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Western Asia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Western Asia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Australia and New Zealand").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Australia and New Zealand"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Asia Pacific").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Western Europe").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Western Europe"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Europe").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Eastern Europe").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Eastern Europe"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Europe").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Central America").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Central America"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("United States").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Western Africa").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Western Africa"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Northern America").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Northern America"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("United States").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Southern Africa").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Southern Africa"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Eastern Africa").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Eastern Africa"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("South-Eastern Asia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "South-Eastern Asia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Asia Pacific").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Eastern Asia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Eastern Asia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Asia Pacific").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Northern Europe").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Northern Europe"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Europe").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Melanesia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Melanesia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Micronesia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Micronesia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
    
    if(Unsubregion.find_by_name("Central Asia").nil?)
      unsubregion = Unsubregion.new
      unsubregion.name = "Central Asia"
      unsubregion.equinixregion_id = Equinixregion.find_by_region_name("Other").id
      unsubregion.save!
    end
  end

  def self.down
    drop_table :unsubregions
  end
end
