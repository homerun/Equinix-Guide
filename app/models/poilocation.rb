class Poilocation < ActiveRecord::Base
  belongs_to :country
  
  validates_presence_of :location_name, :location_type
end
