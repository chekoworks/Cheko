class RenameTypeQnas < ActiveRecord::Migration[6.0]
  def change
    rename_column :qnas, :type, :qna_type
  end
end
