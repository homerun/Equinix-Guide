class CreateServiceGuidelines < ActiveRecord::Migration
  def self.up
    create_table :service_guidelines do |t|
      t.integer :service_id
      t.text :guideline_text
      t.datetime :effective_date
      t.timestamps
    end
  end

  def self.down
    drop_table :service_guidelines
  end
end