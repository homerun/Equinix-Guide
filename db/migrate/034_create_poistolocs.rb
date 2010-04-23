class CreatePoistolocs < ActiveRecord::Migration
  def self.up
    create_table :poistolocs do |t| 
      t.integer :pointsofinterest_id, :poilocation_id
      t.timestamps
    end
  end

  def self.down
    drop_table :poistolocs
  end
end

#insert  into `poistolocs`(`id`,`pointsofinterest_id`,`poilocation_id`) 
#values (1,7,1),(2,8,2),(3,9,2),(4,10,3),(5,22,4),(6,23,5);