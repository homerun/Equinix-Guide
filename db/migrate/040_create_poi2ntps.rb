class CreatePoi2ntps < ActiveRecord::Migration
  def self.up
    create_table :poi2ntps do |t|
      t.integer :pointsofinterest_id, :networkterminationpoint_id
      t.integer  :poiconnectiontype_id, :default => Poiconnectiontype.find_by_name("C").id
      t.integer :user_certified, :contest_list
      t.datetime :certified_date
      t.timestamps
    end
  end

  def self.down
    drop_table :poi2ntps
  end
end
