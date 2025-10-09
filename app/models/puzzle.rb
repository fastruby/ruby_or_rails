class Puzzle < ApplicationRecord
  enum :answer, ruby: 0, rails: 1
  enum :state, { approved: 0, rejected: 1, pending: 2, archived: 3 }
  has_many :answers

  validates :question, presence: true

  scope :archived, -> { where(state: :archived).order(sent_at: :desc) }
end
