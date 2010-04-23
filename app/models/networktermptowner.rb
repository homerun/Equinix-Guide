class Networktermptowner < ActiveRecord::Base
  has_many :networkterminationpoints, :order => :name
  has_many :campuses, :dependent => :nullify
  has_many :news2ntpowners, :dependent => :destroy
  has_many :newsitems, :through => :news2ntpowners
  
  validates_presence_of :name
  validates_uniqueness_of :name
end