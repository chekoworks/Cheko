class AddTypeQna < ActiveRecord::Migration[6.0]
  def change
    add_column :qnas, :type, :integer
  end
end
