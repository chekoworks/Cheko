class ConversationImage < ApplicationRecord
  belongs_to :conversation, optional: true
end
