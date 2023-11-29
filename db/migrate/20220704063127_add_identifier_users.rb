class AddIdentifierUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :identifier_string, :string
    add_column :tutors, :identifier_string, :string
  end
end
