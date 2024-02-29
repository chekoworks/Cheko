class CreateConversationSources < ActiveRecord::Migration[6.0]
  def change
    create_table :conversation_sources do |t|
      t.integer :conversation_id
      t.string :prompt_title
      t.jsonb :result

      t.timestamps
    end
  end
end
