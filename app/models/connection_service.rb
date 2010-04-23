class ConnectionService < ActiveRecord::Base
  belongs_to :np2ntp
  belongs_to :connection_service_description
end