class AddManagerIdHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :manager_id, :integer
  end
end
