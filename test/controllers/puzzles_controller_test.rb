require "test_helper"

class PuzzlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get puzzles_path
    assert_response :success
  end

  test "should show error message when editing puzzle with invalid data" do
    puzzle = puzzles(:one)

    patch puzzle_path(puzzle), params: {
      puzzle: {
        question: "",
        answer: "rails",
        explanation: "Updated explanation",
        link: "https://example.com"
      }
    }, as: :turbo_stream

    assert_response :unprocessable_entity

    assert_select "div.field-error", "can't be blank"
    assert_select "textarea.error"
  end

  test "should successfully update puzzle with valid data" do
    puzzle = puzzles(:one)

    patch puzzle_path(puzzle), params: {
      puzzle: {
        question: "Updated question",
        answer: "rails",
        explanation: "Updated explanation",
        link: "https://example.com"
      }
    }, as: :turbo_stream

    assert_response :success

    puzzle.reload
    assert_equal "Updated question", puzzle.question
    assert_equal "Updated explanation", puzzle.explanation
  end
end
