class EquinixInterMarketLatencytime < ActiveRecord::Base
  belongs_to :latencytime
  belongs_to :a_np2ntp, :class_name => 'Np2ntp', :foreign_key => 'a_np2ntp_id'
  belongs_to :b_np2ntp, :class_name => 'Np2ntp', :foreign_key => 'b_np2ntp_id'
  belongs_to :a_networkterminationpoint, :class_name => 'Networkterminationpoint', :foreign_key => 'a_networkterminationpoint_id'
  belongs_to :b_networkterminationpoint, :class_name => 'Networkterminationpoint', :foreign_key => 'b_networkterminationpoint_id'
  belongs_to :a_market, :class_name => 'Market', :foreign_key => 'a_market_id'
  belongs_to :b_market, :class_name => 'Market', :foreign_key => 'b_market_id'
end
