module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
    markdown.render(text.to_s).html_safe
  end
end
