class UserCustomerGroup < ActiveRecord::Base
  belongs_to :customer_group
  belongs_to :user
end