class Reporttype < ActiveRecord::Base
  has_many :reports, :dependent => :nullify
  
  validates_presence_of :controller_name, :page_name
end
