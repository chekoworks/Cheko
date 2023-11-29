class CreateProfessors < ActiveRecord::Migration[6.0]
  def change
    create_table :professors do |t|
      t.string :first_name
      t.string :last_name
      t.integer :school
      t.integer :easiness
      t.integer :effectiveness
      t.integer :life_changing
      t.integer :light_workload
      t.integer :leniency
      t.float :average
      t.integer :a_able
      t.integer :b_pls_able
      t.integer :b_able
      t.integer :c_able
      t.integer :batch1_able
      t.integer :batch2_able
      t.integer :batch3_able
      t.integer :batch4_able
      t.integer :bad_comments
      t.text :our_comments
      t.integer :status
      t.string :subject
      t.timestamps
    end
  end
end
