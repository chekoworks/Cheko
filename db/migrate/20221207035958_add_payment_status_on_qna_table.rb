class AddPaymentStatusOnQnaTable < ActiveRecord::Migration[6.0]
  def change
    add_column :qnas, :payment_status, :integer
  end
end
