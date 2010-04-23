class CreateReportparameters < ActiveRecord::Migration
  def self.up
    create_table :reportparameters do |t|
      t.integer :report_id
      t.string :key
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :reportparameters
  end
end
