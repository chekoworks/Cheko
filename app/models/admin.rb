class Admin < ApplicationRecord
  require 'net/http'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable
  has_many :documents, as: :documentable, dependent: :destroy

  enum role: { super_admin: 0, admin: 1 }
  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def create_agent
    uri = URI('https://chatwoot.chekohomeworkhelp.com/api/v1/accounts/1/agents')
    params = {
      name: self.name,
      email: self.email,
      role: "agent",
      availability_status: "available",
      auto_offline: true,
      "agent[name]" => self.name,
      "agent[email]" => self.email,
      "agent[role]" => "administrator",
      "agent[availability_status]" => "available",
      "agent[auto_offline]" => true
    }   

    # "api_access_token" = "N7kvJH1xqrVgac3Yq5zkEZw4"
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(params)
    req["api_access_token"] = "Eg2NEZNp4BakhcoS1bPgCHGw"
    res = http.request(req)
    puts res.body
  end
end
