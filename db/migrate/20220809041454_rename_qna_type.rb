class RenameQnaType < ActiveRecord::Migration[6.0]
  def change
    rename_column :qnas, :qna_type, :qna_type_id
  end
end
