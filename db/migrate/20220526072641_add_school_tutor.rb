class AddSchoolTutor < ActiveRecord::Migration[6.0]
  def change
    add_column :tutors, :school, :integer
  end
end
