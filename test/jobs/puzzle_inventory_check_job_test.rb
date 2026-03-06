require "test_helper"

class PuzzleInventoryCheckJobTest < ActiveJob::TestCase
  setup do
    Puzzle.approved.where(sent_at: nil).delete_all
  end

  test "sends notification when fewer than 5 approved unsent puzzles exist" do
    3.times do |i|
      Puzzle.create!(
        question: "Approved unsent puzzle #{i}",
        answer: "ruby",
        state: :approved,
        sent_at: nil,
        explanation: "Test explanation",
        suggested_by: "test_user"
      )
    end

    notification_sent = false
    job = PuzzleInventoryCheckJob.new
    job.define_singleton_method(:send_message) { |*| notification_sent = true }
    job.perform

    assert notification_sent, "Expected a low inventory notification to be sent"
  end

  test "does not send notification when 5 or more approved unsent puzzles exist" do
    5.times do |i|
      Puzzle.create!(
        question: "Approved unsent puzzle #{i}",
        answer: "ruby",
        state: :approved,
        sent_at: nil,
        explanation: "Test explanation",
        suggested_by: "test_user"
      )
    end

    notification_sent = false
    job = PuzzleInventoryCheckJob.new
    job.define_singleton_method(:send_message) { |*| notification_sent = true }
    job.perform

    assert_not notification_sent, "Expected no notification to be sent"
  end

  test "only counts approved puzzles, not pending or rejected" do
    5.times do |i|
      Puzzle.create!(
        question: "Pending puzzle #{i}",
        answer: "ruby",
        state: :pending,
        sent_at: nil,
        explanation: "Test explanation",
        suggested_by: "test_user"
      )
    end

    notification_sent = false
    job = PuzzleInventoryCheckJob.new
    job.define_singleton_method(:send_message) { |*| notification_sent = true }
    job.perform

    assert notification_sent, "Pending puzzles should not count toward approved inventory"
  end

  test "only counts unsent puzzles" do
    5.times do |i|
      Puzzle.create!(
        question: "Already sent puzzle #{i}",
        answer: "ruby",
        state: :approved,
        sent_at: 1.day.ago,
        explanation: "Test explanation",
        suggested_by: "test_user"
      )
    end

    notification_sent = false
    job = PuzzleInventoryCheckJob.new
    job.define_singleton_method(:send_message) { |*| notification_sent = true }
    job.perform

    assert notification_sent, "Already sent puzzles should not count toward available inventory"
  end
end
