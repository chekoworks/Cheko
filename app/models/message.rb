class Message < ApplicationRecord
  belongs_to :chat

  has_one_attached :document

  validate :has_email
  validate :has_numbers
  validate :has_links

  def has_email
    return unless Regexp.new('\b^.+@.+$\b').match(self.content)
    errors.add(:base, 'There is an email address on your message')
  end

  def has_numbers
    return unless Regexp.new('\b[0-9]{10,12}$\b').match(self.content)
    errors.add(:base, 'There is a telephone/mobile number on your message')
  end

  def has_links
    keyword_array = ["messenger.com", "whatsapp.com"]
    return unless keyword_array.any? { |word| Regexp.new('\b' + word + '\b').match(self.content) }
    errors.add(:base, 'You added a banned link.')
  end
end
