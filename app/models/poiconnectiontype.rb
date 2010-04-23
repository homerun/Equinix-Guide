class Poiconnectiontype < ActiveRecord::Base
  has_many :poi2ntps, :dependent => :destroy
  has_many :poi2ntps, :dependent => :destroy
  
  validates_presence_of :name, :description
end