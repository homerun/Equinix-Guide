class Datacenter < ActiveRecord::Base
  belongs_to :country
  belongs_to :datacentercompany
  has_many :np2dcs, :dependent => :destroy
  
  validates_presence_of :datacentercompany_id
end
