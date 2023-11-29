class AddMoreFieldsHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :updates, :text
    add_column :homeworks, :payment_received, :datetime
    add_column :homeworks, :file_received, :datetime
    add_column :homeworks, :tutor_price, :integer
  end
end
