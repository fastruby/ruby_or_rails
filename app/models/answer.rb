class Answer < ApplicationRecord
  belongs_to :puzzle
  belongs_to :user
end
