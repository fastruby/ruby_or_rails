class User < ApplicationRecord
  has_and_belongs_to_many :servers, join_table: "users_servers"
  has_many :answers

  enum :role, admin: 0, member: 1
end
