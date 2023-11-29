class AddDeletedAtColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :soft_deleted, :boolean, default: false
    add_column :homeworks, :deleted_at, :datetime
  end
end
