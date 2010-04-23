class News2np < ActiveRecord::Base
  belongs_to :np, :class_name => 'Networkprovider', :foreign_key => :networkprovider_id
  belongs_to :newsitem
  
  validates_presence_of :networkprovider_id, :newsitem_id
end