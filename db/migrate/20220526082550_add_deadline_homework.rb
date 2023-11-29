class AddDeadlineHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :deadline, :datetime
  end
end
