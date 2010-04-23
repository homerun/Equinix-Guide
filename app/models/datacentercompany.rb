class Datacentercompany < ActiveRecord::Base
  has_many :datacenters
  
  validates_presence_of :company
end
