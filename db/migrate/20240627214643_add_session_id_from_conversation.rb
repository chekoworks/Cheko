class AddSessionIdFromConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :conversations, :session_id, :string
  end
end
