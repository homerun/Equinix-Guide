class CreateOthertags < ActiveRecord::Migration
  def self.up
    create_table :othertags do |t|
      t.string :tag
      t.timestamps
    end
    
    ["Korea", "equities", "futures", "power outage", "outage", "low-latency", "NASDAQ OMX", "dark pool", "mutual recognition", "algorithmic trading", "latency"].each do |t|
      tag = Othertag.new
      tag.tag = t
      tag.save!
    end
  end

  def self.down
    drop_table :othertags
  end
end
