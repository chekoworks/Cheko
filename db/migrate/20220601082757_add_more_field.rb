class AddMoreField < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :subject, :string
    add_column :homeworks, :sub_type, :string
    add_column :homeworks, :sub_subject, :string
    add_column :homeworks, :priority, :boolean
    add_column :homeworks, :tutor_skills, :boolean
    add_column :homeworks, :tutor_samples, :boolean
    add_column :homeworks, :view_bidders, :boolean
    add_column :homeworks, :login_school, :boolean
    add_column :homeworks, :received, :datetime
    add_column :homeworks, :hours_late, :integer
    add_column :homeworks, :notes, :text
    add_column :homeworks, :prof, :string
    add_column :homeworks, :grade_get, :integer
    add_column :homeworks, :sub_tutor_id, :integer
    add_column :homeworks, :tutor_category, :integer
    add_column :homeworks, :budget, :integer
    
    add_column :tutors, :category, :integer

    add_column :users, :level, :integer
  end
end
