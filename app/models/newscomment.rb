class Newscomment < ActiveRecord::Base
  belongs_to :user
  belongs_to :newsitem
  belongs_to :newscomment, :foreign_key => 'parent_comment_id'
  has_many :newscomments, :foreign_key => 'parent_comment_id', :dependent => :destroy
end
