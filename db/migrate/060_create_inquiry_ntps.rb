class CreateInquiryNtps < ActiveRecord::Migration
  def self.up
    create_table :inquiry_ntps do |t|
      t.integer :inquiry_id, :networkterminationpoint_id, :networkprovider_id
      t.timestamps
    end
  end

  def self.down
    drop_table :inquiry_ntps
  end
end
