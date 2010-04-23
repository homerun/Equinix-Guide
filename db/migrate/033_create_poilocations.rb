class CreatePoilocations < ActiveRecord::Migration
  def self.up
    create_table :poilocations do |t|
      t.string :location_name, :street_address, :city, :state_or_province, :zip_code, :country
      t.integer :country_id#, :location_type
      t.decimal :lat, :lon
      t.timestamps
    end
  end

  def self.down
    drop_table :poilocations
  end
end

#insert  into `poilocations`(`id`,`locationName`,`locationType`,`street_address`,`city`,`state_or_province`,`zip_code`,`country`,`countryCode`,`lat`,`lon`) 
#values (1,'Ichiban-cho Tokyu Building',0,'21 Ichiban-cho','Chiyoda-ku, Tokyo',NULL,'102-0082','Japan',392,'0.0000000','0.0000000'),(2,'KRE and Stock Exchange',0,'33, Yeouido-dong','Yeongdeungpo-gu, Seoul',NULL,'150-977','Korea',408,'0.0000000','0.0000000'),(3,'KOFEX',0,'600-015 50 Jungang-dong 5-Ga','Joong-gu, Busan',NULL,NULL,'Korea',408,'0.0000000','0.0000000'),(4,'Tokyo Commodity Exchange',0,'10-7 Nihonbashi Horidomecho 1-Chome','Chuo-ku, Tokyo',NULL,'103-0012','Japan',392,'35.6833740','139.7762950'),(5,'Osaka Securities Exchange',0,'8-16, Kitahama 1-chome, Chuo-ku','Osaka',NULL,'541-0041','Japan',392,'0.0000000','0.0000000');