class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :tutor_id
      t.text :details
      t.timestamps
    end
  end
end
