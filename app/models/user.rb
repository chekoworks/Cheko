class User < ApplicationRecord
  require 'openssl'
  require 'base64'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :homeworks, dependent: :destroy
  has_many :prof_reviews
  # has_many :chats, as: :chattable, dependent: :destroy
  has_many :qnas, dependent: :destroy
  # has_many :messages, as: :sendable, dependent: :destroy
  has_many :conversations, dependent: :destroy

  after_create :create_identifier

  enum status: { inactive: 0, active: 1 }
  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def create_identifier
    key = "3uBthMvyxxfCWMvndnpXKZbW"
    message = "#{self.id}-client"
    idd = OpenSSL::HMAC.hexdigest('sha256', key, message)

    self.update(identifier_string: idd)
  end

  def next_humanize_available_date
    if self.last_humanize_used_date.nil?
      return Time.current
    end

    self.last_humanize_used_date  + 1.hour
  end

  def is_humanize_available
    if self.last_humanize_used_date.nil?
      true
    end

    Time.current >= self.next_humanize_available_date
  end

  # def create_contact
  #   uri = URI('http://localhost:4000/public/api/v1/inboxes/FEKYxKAmz9wq1jU35a8dNv3M/contacts')
  #   params = {
  #     email: self.email,
  #     name: self.name
  #   }

  #   http = Net::HTTP.new(uri.host, uri.port)
  #   req = Net::HTTP::Post.new(uri.request_uri)
  #   req.set_form_data(params)
  #   res = http.request(req)
  #   result = JSON.parse(res.body)
  #   puts result
  #   self.contact_id = result["source_id"]
  # end
end


# public/api/v1/inboxes/FEKYxKAmz9wq1jU35a8dNv3M/contacts/8645901/conversations
