class CreateNp2ntps < ActiveRecord::Migration
  def self.up
    create_table :np2ntps do |t|
      t.integer :networkterminationpoint_id, :networkprovider_id, :connectiontype_id
      t.integer :user_certified, :contest_list
      t.datetime :certified_date
      t.timestamps
    end
  end

  def self.down
    drop_table :np2ntps
  end
end
