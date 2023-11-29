class CreateProfReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :prof_reviews do |t|
      t.integer :professor_id
      t.integer :user_id
      t.integer :status
      t.text :content
      t.timestamps
    end
  end
end
