class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :user_id, :reporttype_id
      t.string :report_title
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
