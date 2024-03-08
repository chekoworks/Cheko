class HumanizeAnswer < ApplicationRecord
  belongs_to :conversation, optional: true
end
