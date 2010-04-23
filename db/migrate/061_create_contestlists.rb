class CreateContestlists < ActiveRecord::Migration
  def self.up
    create_table :contestlists do |t|
      t.string :field_name, :connection_table
      t.timestamps
    end
  end

  def self.down
    drop_table :contestlists
  end
end
