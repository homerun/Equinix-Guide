class CreatePoitypes < ActiveRecord::Migration
  def self.up
    create_table :poitypes do |t|
      t.string :name
      t.timestamps
    end
    
    ["Exchange", "Not Classified", "Clearing House", "Alternative Trading System (ATS)", "Electronic Communications Network (ECN)","OTC Market", "Unregistered Securities (144A)", "Multilateral Trading Facility (MTF)", "Trade Reporting"].each do |t|
      poitype = Poitype.new
      poitype.name = t
      poitype.save!
    end
  end

  def self.down
    drop_table :poitypes
  end
end
