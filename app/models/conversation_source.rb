require 'domainatrix'

class ConversationSource < ApplicationRecord
  belongs_to :conversation, optional: true

  def self.site_name(url)
    parsed_url = Domainatrix.parse(url)
    parsed_url.domain
  end
end
