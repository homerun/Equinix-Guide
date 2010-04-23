class CreateUserActivitySessions < ActiveRecord::Migration
  def self.up
    create_table :user_activity_sessions do |t|
      t.integer :user_id
      t.datetime :first_activity, :last_activity
      t.string :ip_address
      t.string :activity_type, :size => 1
    end
    #add_column :user_activity_sessions, :activity_type, :string, :size => 1
  end

  def self.down
    drop_table :user_activity_sessions
  end
end
