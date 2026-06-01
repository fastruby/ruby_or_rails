module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)

    # Redcarpet needs the codeblocks to have 2 newlines before them
    # fixing this at render because it's not really required by Discord
    # it's just a quirk of Redcarpet
    if text.match?(/[^\n]\n```(.*)\n```/m)
      text = text.gsub(/([^\n])\n```(.*?)\n```/m, "\\1\n\n```\\2\n```")
    end

    markdown.render(text.to_s).html_safe
  end
end
