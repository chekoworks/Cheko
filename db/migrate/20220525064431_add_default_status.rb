class AddDefaultStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :managers, :status, :integer, :default => 1
    change_column :admins, :status, :integer, :default => 1
    change_column :users, :status, :integer, :default => 1
    change_column :tutors, :status, :integer, :default => 0
  end
end
