class Connectiontype < ActiveRecord::Base
  has_many :np2dcs, :dependent => :nullify
  has_many :np2ntps, :dependent => :nullify
  has_many :np2pois, :dependent => :destroy
  
  validates_presence_of :name
end