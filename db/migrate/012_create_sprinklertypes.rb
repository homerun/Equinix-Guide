class CreateSprinklertypes < ActiveRecord::Migration
  def self.up
    create_table :sprinklertypes do |t|
        t.string :sprinkler_type
        t.timestamps
      end

      ["Dry pipe pre-action", "Dry fill"].each do |s|
        sprinkler_type = Sprinklertype.new
        sprinkler_type.sprinkler_type = s
        sprinkler_type.save!
      end
  end

  def self.down
    drop_table :sprinklertypes
  end
end
