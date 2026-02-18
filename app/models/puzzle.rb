class Puzzle < ApplicationRecord
  enum :answer, ruby: 0, rails: 1
  enum :state, { approved: 0, rejected: 1, pending: 2, archived: 3 }
  has_many :answers

  belongs_to :original_puzzle, class_name: "Puzzle", optional: true

  validates :question, presence: true

  scope :archived, -> { where(state: :archived).order(sent_at: :desc) }

  def correct_answer_percentage
    total = answers.count
    return 0 if total.zero?

    (answers.where(is_correct: true).count * 100.0 / total).round(1)
  end
end
