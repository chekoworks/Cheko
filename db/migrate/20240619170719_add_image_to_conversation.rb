class AddImageToConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :conversations, :images, :jsonb
  end
end
