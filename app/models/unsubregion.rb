class Unsubregion < ActiveRecord::Base
  has_many :pois, :class_name => 'Pointsofinterest', :order => 'name', :dependent => :nullify
  belongs_to :equinixregion
  has_many :countries, :order => 'name', :dependent => :nullify
  has_many :networkterminationpoints, :through => :countries
end