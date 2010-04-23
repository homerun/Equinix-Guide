class RemoveInquiryLatencyTimesField < ActiveRecord::Migration
  
  def self.up
    remove_column :inquiry_latency_times, :response_connectiontype_id
  end

  def self.down
    add_column :inquiry_latency_times, :response_connectiontype_id, :integer
  end

end