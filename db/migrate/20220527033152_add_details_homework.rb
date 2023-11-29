class AddDetailsHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :details, :text
  end
end
