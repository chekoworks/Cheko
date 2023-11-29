class AddNameHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :name, :string
  end
end
