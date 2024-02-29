class ConversationRelated < ApplicationRecord
  belongs_to :conversation, optional: true
end
