class CreateUserlists < ActiveRecord::Migration
  def self.up
    create_table :userlists do |t|
      t.string :table_name, :field_name
      t.timestamps
    end
  end

  def self.down
    drop_table :userlists
  end
end
