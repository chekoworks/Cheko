class RenameTypeHomework < ActiveRecord::Migration[6.0]
  def change
    rename_column :homeworks, :type, :order_type
  
  end
end
