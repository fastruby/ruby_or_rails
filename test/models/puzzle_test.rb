require "test_helper"

class PuzzleTest < ActiveSupport::TestCase
  test "validates presence of question" do
    puzzle = Puzzle.new(
      question: "What is the capital of France?",
      answer: "rails",
      explanation: "This is a test puzzle",
      link: "https://example.com",
      state: "approved",
      suggested_by: "test_user"
    )
    assert puzzle.valid?
  end

  test "validates question presence - fails without question" do
    puzzle = Puzzle.new(
      answer: "rails",
      explanation: "This is a test puzzle",
      link: "https://example.com",
      state: "approved",
      suggested_by: "test_user"
    )
    assert_not puzzle.valid?
    assert_includes puzzle.errors[:question], "can't be blank"
  end

  test "defines answer enum with correct values" do
    assert_equal 0, Puzzle.answers[:ruby]
    assert_equal 1, Puzzle.answers[:rails]
  end

  test "defines state enum with correct values" do
    assert_equal 0, Puzzle.states[:approved]
    assert_equal 1, Puzzle.states[:rejected]
    assert_equal 2, Puzzle.states[:pending]
    assert_equal 3, Puzzle.states[:archived]
  end

  test "defaults state to pending" do
    puzzle = Puzzle.new(
      question: "Test question",
      answer: "ruby",
      explanation: "Test explanation"
    )
    assert_equal "pending", puzzle.state
  end

  test "has many answers" do
    assert_respond_to Puzzle.new, :answers
  end

  test "only_low_success_rate includes only puzzles with less than or equal 80%" do
    puzzles = Puzzle.archived
    assert_includes puzzles, puzzles(:archived_low_rate)
    assert_includes puzzles, puzzles(:archived_high_rate)

    puzzles = Puzzle.archived.only_low_success_rate
    assert_includes puzzles, puzzles(:archived_low_rate)
    assert_not_includes puzzles, puzzles(:archived_high_rate)
  end
end
