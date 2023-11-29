class AddPaymentDetailsOnQnaTable < ActiveRecord::Migration[6.0]
  def change
    add_column :qnas, :amount, :integer
    add_column :qnas, :date_paid, :datetime
  end
end
