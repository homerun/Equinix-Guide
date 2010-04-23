class CreateSharedreports < ActiveRecord::Migration
  def self.up
    create_table :sharedreports do |t|
      t.integer :user_id, :report_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sharedreports
  end
end
