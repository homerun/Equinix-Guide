class Country < ActiveRecord::Base
  has_many :poilocations 
  has_many :datacenters
  belongs_to :subregion, :class_name => 'Unsubregion', :foreign_key => :unsubregion_id
  has_many :poiaccountexecutives, :dependent => :nullify
  has_many :networkterminationpoints, :dependent => :nullify
  has_many :markets
  
  validates_presence_of :name, :alpha2
end
