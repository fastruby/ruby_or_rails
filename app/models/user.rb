class User < ApplicationRecord
  has_and_belongs_to_many :servers
  has_many :servers

  enum :role, admin: 0, member: 1
end
