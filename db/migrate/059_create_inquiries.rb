class CreateInquiries < ActiveRecord::Migration
  def self.up
    create_table :inquiries do |t|
      t.integer :inquiry_creator_id, :inquiry_sender_id, :inquire_to_user_contact
      t.string :inquiry_type
      t.text :notes
      t.datetime :response_date
      t.timestamps
    end
  end

  def self.down
    drop_table :inquiries
  end
end
