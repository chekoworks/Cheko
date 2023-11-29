class AddThemeUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :theme, :string, default: "light"
    add_column :admins, :theme, :string, default: "light"
    add_column :tutors, :theme, :string, default: "light"
    add_column :accountants, :theme, :string, default: "light"
    add_column :quality_officers, :theme, :string, default: "light"
    add_column :managers, :theme, :string, default: "light"
  end
end
