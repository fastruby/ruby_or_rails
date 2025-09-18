class Answer < ApplicationRecord
  belongs_to :puzzle
  belongs_to :user

  validates :puzzle_id, uniqueness: { scope: [ :user_id, :server_id ] }
end
