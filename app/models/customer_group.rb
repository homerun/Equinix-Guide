class CustomerGroup < ActiveRecord::Base
  has_many :user_customer_groups, :dependent => :destroy
  has_many :customer_group_rules, :dependent => :destroy
  has_many :users, :through => :user_customer_groups
end