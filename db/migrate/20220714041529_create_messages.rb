class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :chat_id
      t.text :content
      t.integer :sendable_id
      t.string :sendable_type

      t.timestamps
    end
  end
end
