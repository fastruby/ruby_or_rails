module ApplicationHelper
  def markdown(text)
    RedcarpetCompat.new(text, :fenced_code).to_html.html_safe
  end
end
