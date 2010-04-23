class ModifyInquiries < ActiveRecord::Migration
  def self.up

    add_column :inquiry_ntps, :inquiry_type, :string
    add_column :inquiry_ntps, :response_date, :date
    add_column :inquiry_ntps, :response_connectiontype_id, :integer
    add_column :inquiry_ntps, :creator_id, :integer
    
    inquiries = Inquiry.find(:all)
    inquiries.each do |inquiry|
      inquiryNtp = InquiryNtp.new({:inquiry_id => inquiry.id, 
                                   :creator_id => inquiry.inquiry_creator_id,
                                   :networkterminationpoint_id => inquiry.inquiry_table_id,
                                   :networkprovider_id =>  inquiry.inquire_to_table_id, 
                                   :inquiry_type => inquiry.inquiry_type,
                                   :response_date => inquiry.response_date})
      inquiryNtp.save!
    end
    
    rename_table :inquiry_ntps, :inquiry_np2ntps
    
    remove_column :inquiries, :inquiry_type
    remove_column :inquiries, :response_date
    remove_column :inquiries, :inquiry_creator_id
    remove_column :inquiries, :inquire_to_user_contact
    remove_column :inquiries, :inquiry_table
    remove_column :inquiries, :inquire_to_table
    remove_column :inquiries, :inquiry_table_id
    remove_column :inquiries, :inquire_to_table_id
    rename_column :inquiries, :inquire_to_user, :inquire_to_user_id
    
    create_table :inquiry_latency_times do |t|
      t.integer :inquiry_id, :a_np2ntp_id, :b_np2ntp_id, :networkprovider_id, :response_connectiontype_id, :creator_id
      t.string :inquiry_type
      t.date :response_date
      t.decimal :response_latency_time, { :precision => 12, :scale => 7 }
      t.timestamps
    end
    
    Inquiry.find(:all).each do |inquiry|
      if inquiry.sent_at.blank? then
        inquiry.inquiry_np2ntps.each do |inquiry_np2ntp|
          inquiry_np2ntp.inquiry_id = nil
          inquiry_np2ntp.save!
        end unless inquiry.inquiry_np2ntps.nil?
        Inquiry.delete(inquiry.id)
      end
    end
  end
  
  def self.down

    drop_table :inquiry_latency_times
    
    add_column :inquiries, :inquiry_type
    add_column :inquiries, :response_date
    add_column :inquiries, :inquiry_table
    add_column :inquiries, :inquire_to_table
    add_column :inquiries, :inquiry_table_id
    add_column :inquiries, :inquire_to_table_id
    add_column :inquiries, :inquiry_creator_id
    add_column :inquiries, :inquire_to_user_contact
    rename_column :inquiries, :inquire_to_user_id, :inquire_to_user
    
    rename_table :inquiry_np2ntps, :inquiry_ntps
    
    inquiryNtps = InquiryNtp.find(:all)
    inquiryNtps.each do |inquiryNtp|
      unless inquiryNtp.inquiry_id.nil?
        inquiry = Inquiry.find_by_id(inquiryNtp.inquiry_id) 
        inquiry.inquiry_table = 'Networkterminationpoint'
        inquiry.inquire_to_table = 'Networkprovider'
        inquiry.inquiry_table_id = inquiryNtp.networkterminationpoint_id
        inquiry.inquire_to_table_id = inquiryNtp.networkprovider_id
        inquriy.inquiry_type = inquiryNtp.inquiry_type,
        inquiry.response_date = inquiryNtp.response_date
        inquiry.save!
      end
    end
    
    remove_column :inquiry_ntps, :inquiry_type, :string
    remove_column :inquiry_ntps, :response_date, :date
    remove_column :inquiry_ntps, :response_connectiontype_id, :integer
    remove_column :inquiry_ntps, :creator_id, :integer

  end
end