class Tutor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :bids, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  # has_many :chats, dependent: :destroy
  has_many :qnas
  has_many :messages, as: :sendable, dependent: :destroy

  enum status: { pending: 0, active: 1 }
  enum category: { a_list: 0, cheko_plus: 1, standard: 2 }

  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def create_identifier
    key = "3uBthMvyxxfCWMvndnpXKZbW"
    message = "#{self.id}-tutor"
    idd = OpenSSL::HMAC.hexdigest('sha256', key, message)

    self.update(identifier_string: idd)
  end
end
