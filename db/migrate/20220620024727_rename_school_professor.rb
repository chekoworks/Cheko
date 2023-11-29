class RenameSchoolProfessor < ActiveRecord::Migration[6.0]
  def change
    rename_column :professors, :school, :school_id
    add_column :prof_reviews, :school_name, :string
  end
end
