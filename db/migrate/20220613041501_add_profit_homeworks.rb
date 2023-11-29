class AddProfitHomeworks < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :profit, :integer
  end
end
