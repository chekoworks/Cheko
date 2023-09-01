class AddSoftDeletesToManagers < ActiveRecord::Migration[6.0]
  def change
    add_column :managers, :soft_deleted, :boolean, default: false
    add_column :managers, :deleted_at, :datetime
  end
end
