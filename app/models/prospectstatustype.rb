class Prospectstatustype < ActiveRecord::Base
  has_many :poi2ntps, :dependent => :nullify
end