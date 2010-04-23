class CreateContestlistPoi2ntps < ActiveRecord::Migration
  def self.up
    create_table :contestlist_poi2ntps do |t|
      t.integer :poi2ntp_id
      t.string :field_name, :connection_table
      t.timestamps
    end
  end

  def self.down
    drop_table :contestlist_poi2ntps
  end
end
