class AddVoucherAndOthersHomeworks < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :voucher, :string
    add_column :homeworks, :in_bank, :boolean
  end
end
