class CreateContestlistNp2ntps < ActiveRecord::Migration
  def self.up
    create_table :contestlist_np2ntps do |t|
      t.integer :np2ntp_id
      t.string :field_name, :connection_table
      t.timestamps
    end
  end

  def self.down
    drop_table :contestlist_np2ntps
  end
end
