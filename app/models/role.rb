class Role < ActiveRecord::Base
  has_many :users, :dependent => :nullify
  
  validates_presence_of :name
end
