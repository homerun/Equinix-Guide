class CreatePoipreferrednps < ActiveRecord::Migration
  def self.up
    create_table :poipreferrednps do |t|
      t.integer :pointsofinterest_id, :networkprovider_id
      t.timestamps
    end
  end

  def self.down
    drop_table :poipreferrednps
  end
end

#insert  into `poipreferrednps`(`id`,`pointsofinterest_id`,`networkprovider_id`) values (1,1,1),(2,1,2),(3,17,4),(4,23,4),(5,2,3),(6,24,3),(7,11,3),(8,13,3),(9,14,3),(11,66,3),(12,7,72),(13,7,73),(14,7,74),(15,7,75),(16,7,76),(17,7,77),(18,7,78),(19,7,3),(20,7,79),(21,17,34),(22,17,3),(23,22,35),(24,22,28),(25,210,3),(26,210,4),(27,226,77),(28,226,78),(29,226,127),(30,226,126),(31,226,128),(32,243,5),(33,243,3);