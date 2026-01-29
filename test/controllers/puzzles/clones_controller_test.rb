require "test_helper"

class Puzzles::ClonesControllerTest < ActionDispatch::IntegrationTest
  test "creates a cloned puzzle and redirects to index" do
    original = puzzles(:one)

    sign_in
    assert_difference("Puzzle.count", 1) do
      post puzzle_clone_path(original)
    end

    cloned = Puzzle.order(:id).last
    assert_redirected_to puzzles_path

    assert_equal original.question, cloned.question
    assert_equal original.answer, cloned.answer
    assert_equal original.explanation, cloned.explanation
    assert_equal original.link, cloned.link
    assert_equal original.suggested_by, cloned.suggested_by
    assert_nil cloned.sent_at
    assert_equal "pending", cloned.state
  end

  test "does not allow unauthenticated users to create a clone" do
    original = puzzles(:one)

    assert_no_difference("Puzzle.count") do
      post puzzle_clone_path(original)
    end

    assert_dom "p", "Log in to access the Ruby or Rails admin panel."
  end
end
