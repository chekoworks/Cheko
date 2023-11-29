class AddMoreColumnsUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :course, :string
    add_column :users, :year, :integer
    add_column :users, :college, :string
    add_column :users, :address, :string
    add_column :users, :phone_number, :string
  end
end
