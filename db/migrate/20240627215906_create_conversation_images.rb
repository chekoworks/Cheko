class CreateConversationImages < ActiveRecord::Migration[6.1]
  def change
    create_table :conversation_images do |t|
      t.integer :conversation_id
      t.integer :position
      t.jsonb :images

      t.timestamps
    end
  end
end
