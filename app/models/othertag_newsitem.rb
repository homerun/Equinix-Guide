class OthertagNewsitem < ActiveRecord::Base
  belongs_to :othertag
  belongs_to :newsitem
  
  validates_presence_of :othertag_id, :newsitem_id
end
