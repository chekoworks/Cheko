class AddLastHumanizeDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_humanize_used_date, :datetime
  end
end
