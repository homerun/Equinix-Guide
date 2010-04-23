class CreatePoi2ntpprospects < ActiveRecord::Migration
  def self.up
    create_table :poi2ntpprospects do |t|
      t.integer :pointsofinterest_id, :networkterminationpoint_id, :prospectstatustype_id, :poiconnectiontype_id
      t.timestamps
    end
  end

  def self.down
    drop_table :poi2ntpprospects
  end
end

#  `prospectstatustype_id` int(5) NOT NULL,


#insert  into `poi2ntpprospects`(`id`,`pointsofinterest_id`,`networkterminationpoint_id`,`poiconnectiontype_id`,`prospectstatustype_id`) 
# values (1,2,16,2,4),(2,236,16,1,3);
