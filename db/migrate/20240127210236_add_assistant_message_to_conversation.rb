class AddAssistantMessageToConversation < ActiveRecord::Migration[6.0]
  def change
    add_column :conversations, :assistant_messages, :jsonb
  end
end
