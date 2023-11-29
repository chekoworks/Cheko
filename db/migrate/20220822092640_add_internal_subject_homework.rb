class AddInternalSubjectHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :internal_subject, :string
  end
end
