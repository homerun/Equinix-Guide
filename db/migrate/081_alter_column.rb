class AlterColumn < ActiveRecord::Migration
  def self.up
    change_column :latencytimes, :latency_time, :decimal, { :precision => 12, :scale => 7 }
  end

  def self.down
    change_column :latencytimes, :latency_time, :decimal
  end
end