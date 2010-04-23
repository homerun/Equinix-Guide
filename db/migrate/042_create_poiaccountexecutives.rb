class CreatePoiaccountexecutives < ActiveRecord::Migration
  def self.up
    create_table :poiaccountexecutives do |t|
      t.integer :pointsofinterest_id, :user_id, :country_id 
      t.timestamps
    end
  end

  def self.down
    drop_table :poiaccountexecutives
  end
end

#insert  into `poiaccountexecutives`(`id`,`pointsofinterest_id`,`country_id`,`user_id`) values (1,236,840,55);