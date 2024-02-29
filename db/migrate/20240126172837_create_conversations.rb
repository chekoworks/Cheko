class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.integer :user_id
      t.string :title_name
      t.jsonb :messages
      t.jsonb :user_messages

      t.timestamps
    end
  end
end
