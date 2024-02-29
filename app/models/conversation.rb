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
    markdown.render(content).html_safe
  end
end
