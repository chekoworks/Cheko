class CreateChats < ActiveRecord::Migration[6.0]
  def change
    # destroy first chats table
    # drop_table :chats

    # create new chats
    create_table :chats do |t|
      t.integer :qna_id

      t.timestamps
    end
  end
end
