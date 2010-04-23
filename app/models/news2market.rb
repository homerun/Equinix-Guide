class News2market < ActiveRecord::Base
  belongs_to :market
  belongs_to :newsitem
  
  validates_presence_of :market_id, :newsitem_id
end