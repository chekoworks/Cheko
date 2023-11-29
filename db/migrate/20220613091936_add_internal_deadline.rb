class AddInternalDeadline < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :internal_deadline, :datetime
  end
end
