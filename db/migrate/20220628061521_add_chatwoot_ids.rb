class AddChatwootIds < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :agent_id, :integer
    add_column :managers, :agent_id, :integer
    add_column :users, :contact_id, :string
    add_column :chats, :conversation_id, :string

    add_column :chats, :chattable_id, :integer
    add_column :chats, :chattable_type, :string

    add_column :chats, :admin_id, :integer
    add_column :chats, :manager_id, :integer
    add_column :chats, :name, :string
  end
end
