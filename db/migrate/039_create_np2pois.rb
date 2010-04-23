class CreateNp2pois < ActiveRecord::Migration
  def self.up
    create_table :np2pois do |t|
      t.integer :pointofinterest_id, :connectiontype_id, :networkprovider_id
      t.integer :user_certified, :contest_list
      t.datetime :certified_date
      t.timestamps
    end
  end

  def self.down
    drop_table :np2pois
  end
end

#insert  into `np2pois`(`id`,`pointsofinterest_id`,`networkprovider_id`,`connectiontype_id`,`userCertified`,`certifiedDate`,`contestList`) values (1,1,1,7,NULL,NULL,NULL),(2,1,2,7,NULL,NULL,NULL),(3,17,4,7,NULL,NULL,NULL),(4,23,4,7,NULL,NULL,NULL),(5,2,3,8,NULL,NULL,NULL),(6,24,3,8,NULL,NULL,NULL),(7,11,3,8,NULL,NULL,NULL),(8,13,3,8,NULL,NULL,NULL),(9,14,3,8,NULL,NULL,NULL),(11,66,3,8,NULL,NULL,NULL),(12,7,72,7,NULL,NULL,NULL),(13,7,73,7,NULL,NULL,NULL),(14,7,74,7,NULL,NULL,NULL),(15,7,75,7,NULL,NULL,NULL),(16,7,76,7,NULL,NULL,NULL),(17,7,77,7,NULL,NULL,NULL),(18,7,78,7,NULL,NULL,NULL),(19,7,3,8,NULL,NULL,NULL),(20,7,79,7,NULL,NULL,NULL),(21,17,34,5,NULL,NULL,NULL),(22,17,3,8,NULL,NULL,NULL),(23,22,35,5,NULL,NULL,NULL),(24,22,28,5,NULL,NULL,NULL);
