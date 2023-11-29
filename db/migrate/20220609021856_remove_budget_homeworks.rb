class RemoveBudgetHomeworks < ActiveRecord::Migration[6.0]
  def change
    remove_column :homeworks, :budget


    change_column_default :homeworks, :priority,      from: nil, to: false
    change_column_default :homeworks, :tutor_skills,  from: nil, to: false
    change_column_default :homeworks, :tutor_samples, from: nil, to: false
    change_column_default :homeworks, :view_bidders,  from: nil, to: false
    change_column_default :homeworks, :login_school,  from: nil, to: false

  end
end
