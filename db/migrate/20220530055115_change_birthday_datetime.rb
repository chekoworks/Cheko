class ChangeBirthdayDatetime < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :birthday, 'date USING CAST(birthday AS date)'
  end
end
