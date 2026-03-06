require "test_helper"

class DailyPuzzleJobTest < ActiveJob::TestCase
  test "only selects approved puzzles, not pending or rejected" do
    pending_puzzle = Puzzle.create!(
      question: "Pending puzzle question",
      answer: "ruby",
      explanation: "Test explanation",
      state: :pending,
      sent_at: nil,
      suggested_by: "test_user"
    )
    rejected_puzzle = Puzzle.create!(
      question: "Rejected puzzle question",
      answer: "rails",
      explanation: "Test explanation",
      state: :rejected,
      sent_at: nil,
      suggested_by: "test_user"
    )

    DailyPuzzleJob.perform_now

    assert_nil pending_puzzle.reload.sent_at
    assert_nil rejected_puzzle.reload.sent_at
  end

  test "only selects puzzles that have not been sent yet" do
    already_sent = Puzzle.create!(
      question: "Already sent puzzle question",
      answer: "ruby",
      explanation: "Test explanation",
      state: :approved,
      sent_at: 1.day.ago,
      suggested_by: "test_user"
    )

    DailyPuzzleJob.perform_now

    assert_equal already_sent.reload.sent_at.to_i, 1.day.ago.to_i
  end

  test "marks the selected puzzle as archived and sets sent_at" do
    puzzle = Puzzle.create!(
      question: "Approved unsent puzzle question",
      answer: "ruby",
      explanation: "Test explanation",
      state: :approved,
      sent_at: nil,
      suggested_by: "test_user"
    )

    DailyPuzzleJob.perform_now

    puzzle.reload
    assert_not_nil puzzle.sent_at
    assert_equal "archived", puzzle.state
  end

  test "does nothing when no approved unsent puzzles exist" do
    Puzzle.approved.where(sent_at: nil).delete_all

    assert_nothing_raised do
      DailyPuzzleJob.perform_now
    end
  end
end
