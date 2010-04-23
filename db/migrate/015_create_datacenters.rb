class CreateDatacenters < ActiveRecord::Migration
  def self.up
    create_table :datacenters do |t|
      t.integer :datacentercompany_id, :country_id
      t.string :data_center_abbrv, :street_address, :city, :state_or_province, :zip_code
      t.decimal :lat, :lon
      t.timestamps
    end
    
    dc = Datacenter.new
    dc.datacentercompany_id = Datacentercompany.find_by_company("Equinix")
    dc.data_center_abbrv = "SY1"
    dc.street_address = "Unit B 639 Gardeners Rd."
    dc.city = "Mascot"
    dc.state_or_province = "New South Wales"
    dc.zip_code = "2020"
    dc.country_id = Country.find_by_name("Australia").id
    
    dc = Datacenter.new
    dc.datacentercompany_id = Datacentercompany.find_by_company("Equinix")
    dc.data_center_abbrv = "SG1"
    dc.street_address = "Block 20, Ayer Rajah Crescent"
    dc.city = "Ayer Rajah Industrial Park"
    dc.state_or_province = ""
    dc.zip_code = "139964"
    dc.country_id = Country.find_by_name("Singapore").id
    dc.save!
    
    dc = Datacenter.new
    dc.datacentercompany_id = Datacentercompany.find_by_company("Equinix")
    dc.data_center_abbrv = "HK1"
    dc.street_address = "17/F Global Gateway, 168 Yeung Uk Road"
    dc.city = "Tsuen Wan New Town"
    dc.state_or_province = "Hong Kong SAR"
    dc.zip_code = ""
    dc.country_id = Country.find_by_name("China").id
    dc.save!
    
    dc = Datacenter.new
    dc.datacentercompany_id = Datacentercompany.find_by_company("Equinix")
    dc.data_center_abbrv = "TY1"
    dc.street_address = "TRC – C, Building B-Block, 4th and 5th Floors, 5-1 Heiwajima 6-Chome, Oota-ku"
    dc.city = "Tokyo"
    dc.state_or_province = ""
    dc.zip_code = "143-006"
    dc.country_id = Country.find_by_name("Japan").id
    dc.lat = 35.6224100
    dc.lon = 139.7503420
    dc.save!
  end

  def self.down
    drop_table :datacenters
  end
end



#insert  into `datacenters`(`id`,`dataCenterCompanyId`,`dataCenterAbbrv`,`street_address`,`city`,`state_or_province`,`zip_code`,`country`,`country_id`,`lat`,`lon`) 
# (6,1,'TY2','3-8-21 Higashi Shinagawa, Shinagawa-ku','Tokyo',NULL,'104-0002','Japan',392,'35.6175870','139.7479820'),(7,1,'LA1','600 West 7th Street, 6th Floor','Los Angeles','California','90017','United States',840,NULL,NULL),(8,1,'LA2','818 West 7th Street, Suite 600','Los Angeles','California','90017','United States',840,NULL,NULL),(9,1,'LA3','1920 East Maple Ave.','El Segundo','California','90245-3411','United States',840,NULL,NULL),(11,1,'SV1','11 Great Oaks Blvd.','San Jose','California','95119','United States',840,NULL,NULL),(12,1,'SV2','1350 Duane Ave.','Santa Clara','California','95054','United States',840,NULL,NULL),(13,1,'SV3','1735 Lundy Avenue','San Jose','California','95131','United States',840,NULL,NULL),(14,1,'SV4','255 Caspian Drive','Sunnyvale','California','94089-1015','United States',840,NULL,NULL),(15,1,'DA1','1950 N. Stemmons Fwy, Suite 1034','Dallas','Texas','75207','United States',840,'32.8004060','-96.8200580'),(16,1,'CH1','350 East Cermak Rd, 5th & 6th Floor, Ste 650','Chicago','Illinois','60616','United States',840,'41.8532920','-87.6184200'),(17,1,'CH2','350 East Cermak Rd, 5th & 6th Floor, Ste 650','Chicago','Illinois','60616','United States',840,'41.8532920','-87.6184200'),(18,1,'CH3','1905 Lunt Avenue','Elk Grove Village,','Illinois','60007','United States',840,'42.0020870','-87.9553200'),(19,1,'DC1','21711 & 21715 Filigree Ct., Bldg C','Ashburn','Virginia','20147','United States',840,'39.0163580','-77.4594980'),(20,1,'DC2','21711 & 21715 Filigree Ct., Bldg C','Ashburn','Virginia','20147','United States',840,'39.0163580','-77.4594980'),(21,1,'DC3','44470 Chilum Place, Bldg 1','Ashburn','Virginia','20147','United States',840,NULL,NULL),(22,1,'NY1','165 Halsey Street, 8th Floor','Newark','New Jersey','07102','United States',840,NULL,NULL),(23,1,'NY2','275 Hartz Way','Secaucus','New Jersey','07094','United States',840,NULL,NULL),(25,1,'NY4','755 Secaucus Rd.','Secaucus','New Jersey','07094','United States',840,NULL,NULL),(26,1,'LD1','101 Finsbury Pavement','London',NULL,'EC2A 1RS','United Kingdom',826,'51.5198060','-0.0878160'),(27,1,'LD2','Unit 1, Airport Gate, Bath Road West Drayton','Middlesex',NULL,'UB7 0NJ','United Kingdom',826,'51.4824150','-0.4606640'),(28,1,'LD3','Unit 11 Matrix, Coronation Road, Park Royal','London',NULL,'NW10 7PH','United Kingdom',826,'51.5293380','-0.2727590'),(29,1,'LD4','2 Buckingham Avenue, Slough Trading Estate','Berkshire',NULL,'SL1 4NB','United Kingdom',826,'51.5227280','-0.6288680'),(30,1,'PA1','Paris Nord 2, 167 Rue de la Belle Etoile','Roissy',NULL,'95948','France',250,NULL,NULL),(31,1,'PA2','114 rue Ambroise Croizat','Saint Denis',NULL,'93200','France',250,NULL,NULL),(32,1,'GV1','6 Rue de la Confederation','Geneva',NULL,'CH-1204','Switzerland',756,'46.2034280','6.1446780'),(33,1,'ZH1','Hardstrasse 235','Zürich',NULL,'8005','Switzerland',756,'47.3876870','8.5190230'),(34,1,'ZH2','Josefstrasse 225','Zürich',NULL,'8005','Switzerland',756,'47.3879700','8.5202730'),(35,1,'ZH3','Letzigraben 75','Zürich',NULL,'8003','Switzerland',756,'47.3789630','8.5000490'),(36,1,'DU1','Albertstrasse 27','Düsseldorf',NULL,'40233','Germany',276,'51.2197600','6.8066310'),(37,1,'FR1','Taubenstrasse 7–9','Frankfurt am Main',NULL,'60313','Germany',276,NULL,NULL),(38,1,'FR2','Friesstrasse 26','Frankfurt',NULL,'60388','Germany',276,NULL,NULL),(39,1,'FR3','Starkenburgstraße 12','Mörfelden',NULL,'64 546','Germany',276,NULL,NULL),(40,1,'MU1','Seidlstrasse 3','München',NULL,'80335','Germany',276,NULL,NULL),(41,1,'MU2','Am Moosfeld 37','München',NULL,'81820','Germany',276,NULL,NULL),(42,1,'DC4','21691 Filigree Ct., Bldg E','Ashburn','Virginia','20147','United States',840,NULL,NULL),
# (43,1,'AM1','Luttenbergweg 4','Amsterdam',NULL,'1101 EC','The Netherlands',528,'52.3016040','4.9431180'),(44,1,'ZW1','Telfordsstraat 3','Zwolle',NULL,'8013 RL','The Netherlands',528,'52.4882940','6.1414220'),(45,1,'EN1','Auke Vleerstraat 1','Enschede',NULL,'7521 PE','The Nehtherlands',528,'52.2371930','6.8492780');
