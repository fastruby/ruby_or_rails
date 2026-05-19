class Puzzle < ApplicationRecord
  enum :answer, ruby: 0, rails: 1
  enum :state, { approved: 0, rejected: 1, pending: 2, archived: 3 }
  has_many :answers

  belongs_to :original_puzzle, class_name: "Puzzle", optional: true

  validates :question, presence: true

  scope :archived, -> { where(state: :archived).order(sent_at: :desc) }

  def correct_answer_percentage
    total = answers.size
    return 0 if total.zero?

    correct_count = answers.loaded ? answers.select(&:is_correct).count : answers.where(is_correct: true).count

    (correct_count * 100.0 / total).round(1)
  end

  def clone_puzzle
    attrs = attributes.slice("question", "answer", "explanation", "link", "suggested_by")
    Puzzle.create(attrs.merge(original_puzzle: self, state: "pending"))
  end

  def self.only_low_success_rate
    low_success_rate_ids = includes(:answers).to_a.select { |ans| ans.correct_answer_percentage <= 80 }.map(&:id)
    where(id: low_success_rate_ids)
  end

  def self.without_cloned
    cloned_puzzles_ids = unscoped.where.not(original_puzzle_id: nil).pluck(:original_puzzle_id)
    where.not(id: cloned_puzzles_ids)
  end
end
