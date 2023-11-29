class AddSubjectHomework < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :subject_id, :integer
    add_column :homeworks, :words, :integer
    add_column :homeworks, :tutor_deadline, :datetime
    add_column :homeworks, :price, :integer
    add_column :homeworks, :grade, :integer
    add_column :homeworks, :admin_id, :integer
  end
end
