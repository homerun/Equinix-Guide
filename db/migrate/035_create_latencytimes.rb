class CreateLatencytimes < ActiveRecord::Migration
  def self.up
    create_table :latencytimes do |t|
      t.decimal :latency_time
      t.integer :a_np2ntp_id, :b_np2ntp_id, :networkprovider_id
      t.integer :user_certified, :contest_list
      t.datetime :certified_date
      t.timestamps
    end
  end

  def self.down
    drop_table :latencytimes
  end
end

#insert  into `latencytimes`(`id`,`a_np2ntp_id`,`b_np2ntp_id`,`networkprovider_id`,`latencyTime`,`userCertified`,`certifiedDate`,`contestList`) values (1,258,259,101,'0.330000000000',NULL,NULL,NULL),(2,351,91,82,'98.000000000000',NULL,NULL,NULL),(3,289,358,67,'68.000000000000',NULL,NULL,NULL);
