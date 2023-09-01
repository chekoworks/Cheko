class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :documents, as: :documentable, dependent: :destroy

  has_many :homeworks

  enum status: { inactive: 0, active: 1 }

  scope :not_deleted, -> { where(soft_deleted: false) }
  scope :deleted, -> { where(soft_deleted: true) }

  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def soft_delete
    update(soft_deleted: true)
  end

  def undelete
    update(soft_deleted: false)
  end

  def create_agent
    uri = URI.parse('https://chatwoot.chekohomeworkhelp.com/api/v1/accounts/1/agents')
    params = {
      name: self.name,
      email: self.email,
      role: "agent",
      availability_status: "available",
      auto_offline: true,
      "agent[name]" => self.name,
      "agent[email]" => self.email,
      "agent[role]" => "agent",
      "agent[availability_status]" => "available",
      "agent[auto_offline]" => true
    }   

    # "api_access_token" = "N7kvJH1xqrVgac3Yq5zkEZw4"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(params)
    req["api_access_token"] = "Eg2NEZNp4BakhcoS1bPgCHGw"
    res = http.request(req)
    result = JSON.parse(res.body)
    
    self.update(agent_id: result["id"])
  end

  def assign_inbox
    uri = URI.parse('https://chatwoot.chekohomeworkhelp.com/api/v1/accounts/1/inbox_members')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data({'index_id' => '1', 'users_id[0]' => "#{self.agent_id}"})
    req["api_access_token"] = "Eg2NEZNp4BakhcoS1bPgCHGw"
    res = http.request(req)
    result = JSON.parse(res.body)
    logger.info "\n\n #{result}\n\n"
  end

  def remove_agent
    url = "https://chatwoot.chekohomeworkhelp.com/api/v1/accounts/1/agents/#{self.agent_id}"
    uri = URI.parse(url)
    params = {
      id: self.agent_id,
    }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Delete.new(uri.request_uri)
    req.set_form_data(params)
    req["api_access_token"] = "Eg2NEZNp4BakhcoS1bPgCHGw"
    res = http.request(req)
  end
end
