class AddCoulmnsReview < ActiveRecord::Migration[6.0]
  def change
    add_column :prof_reviews, :first_name, :string
    add_column :prof_reviews, :last_name, :string
    add_column :prof_reviews, :school_id, :integer
    add_column :prof_reviews, :school, :string
    add_column :prof_reviews, :easiness, :integer
    add_column :prof_reviews, :effectiveness, :integer
    add_column :prof_reviews, :life_changing, :integer
    add_column :prof_reviews, :light_workload, :integer
    add_column :prof_reviews, :leniency, :integer
    add_column :prof_reviews, :average, :integer
    add_column :prof_reviews, :a_able, :integer
    add_column :prof_reviews, :b_pls_able, :integer
    add_column :prof_reviews, :b_able, :integer
    add_column :prof_reviews, :c_able, :integer
    add_column :prof_reviews, :batch1_able, :integer
    add_column :prof_reviews, :batch2_able, :integer
    add_column :prof_reviews, :batch3_able, :integer
    add_column :prof_reviews, :batch4_able, :integer
    add_column :prof_reviews, :subject, :string
    change_column :prof_reviews, :status, :integer, default: 1
  end
end
