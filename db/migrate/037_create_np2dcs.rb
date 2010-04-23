class CreateNp2dcs < ActiveRecord::Migration
  def self.up
    create_table :np2dcs do |t|
      t.integer :networkprovider_id, :datacenter_id, :connectiontype_id
      t.timestamps
    end
  end

  def self.down
    drop_table :np2dcs
  end
end

#insert  into `np2dcs`(`id`,`dcId`,`networkprovider_id`,`connectiontype_id`) values (1,1,11,5),(2,5,14,5),(3,6,14,5),(4,5,20,5),(5,6,20,5),(6,5,34,5),(7,6,34,5),(8,5,35,5),(9,6,35,5),(10,5,28,5),(11,6,28,5),(12,5,46,5),(13,6,46,5),(14,5,51,5),(15,6,51,5),(16,5,68,5),(17,6,68,5),(18,5,54,5),(19,6,54,5),(20,5,44,4),(21,6,44,5),(22,5,76,4),(23,5,77,4),(24,5,78,4),(25,5,3,4),(26,6,76,4),(27,6,77,4),(28,6,78,4),(29,6,3,4);