class CreateNewscomments < ActiveRecord::Migration
  def self.up
    create_table :newscomments do |t|
      t.integer :user_id, :parent_comment_id, :newsitem_id
      t.datetime :date_time
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :newscomments
  end
end
