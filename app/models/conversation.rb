require 'redcarpet'

class Conversation < ApplicationRecord
  belongs_to :user, optional: true

  has_many :conversation_relateds
  has_many :conversation_sources

  def self.markdown_to_html(content)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      strikethrough: true,
      lax_html_blocks: true,
      with_toc_data: true
    )
    markdown_content_text_html = markdown.render(content)

    markdown_content_text_html.gsub!(/<\/p>\s*<p>/, "</p>\n<p><br></p>\n<p>")

    # Similarly adjust other spacings using regex patterns
    markdown_content_text_html.gsub!(/<\/p>\s*<ul>/, "</p>\n<p><br></p>\n<ul>")
    markdown_content_text_html.gsub!(/<\/p>\s*<ol>/, "</p>\n<p><br></p>\n<ol>")
    markdown_content_text_html.gsub!(/<\/ol>\s*<p>/, "</ol>\n<p><br></p>\n<p>")
    markdown_content_text_html.gsub!(/<\/ul>\s*<p>/, "</ul>\n<p><br></p>\n<p>")

    markdown_content_text_html.html_safe
  end
end
