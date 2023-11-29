class AddColumnsHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :status, :integer
    add_column :homeworks, :type, :integer
    add_column :homeworks, :payment_status, :integer
    add_column :homeworks, :payment_type, :integer
  end
end
