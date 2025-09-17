class Server < ApplicationRecord
  has_and_belongs_to_many :users, join_table: "users_servers"
  has_one :channel
end
