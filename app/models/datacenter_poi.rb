class DatacenterPoi < ActiveRecord::Base
  belongs_to :networkterminationpoint
  belongs_to :country
  belongs_to :market
  belongs_to :poi2ntp
end
