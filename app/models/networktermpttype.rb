class Networktermpttype < ActiveRecord::Base
  has_many :networkterminationpoints
  
  validates_uniqueness_of :name
end