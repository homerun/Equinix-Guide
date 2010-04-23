class Othertag < ActiveRecord::Base
  has_many :othertag_newsitems, :dependent => :destroy
  has_many :newsitems, :through => :othertag_newsitems
  
  validates_presence_of :tag
end
