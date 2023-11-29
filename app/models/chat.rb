class Chat < ApplicationRecord
  belongs_to :qna
  
  has_many :messages
end
