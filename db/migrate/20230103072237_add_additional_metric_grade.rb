class AddAdditionalMetricGrade < ActiveRecord::Migration[6.0]
  def change
    add_column :prof_reviews, :additional_metric_grade, :integer
    add_column :professors, :additional_metric_grade, :integer, after: :batch4_able
  end
end
