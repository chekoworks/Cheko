class AddDefaultHomework < ActiveRecord::Migration[6.0]
  def change
    change_column :homeworks, :status, :integer, :default => 0
  end
end
