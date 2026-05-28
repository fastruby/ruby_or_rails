require "test_helper"

class MarkdownHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "renders `code` with code tag" do
    puzzle_content = "Some content with `some code` in it"
    as_html = markdown(puzzle_content)

    assert_includes as_html, "<code>some code</code>"
  end

  test "renders ```code``` with code block" do
    puzzle_content = <<~CONTENT
    Some content with

    ```
    class ACodeBlock
    end
    ```
    in it
    CONTENT
    as_html = markdown(puzzle_content)

    assert_includes as_html, "<pre><code>class ACodeBlock"
  end
end
