class CreateQnas < ActiveRecord::Migration[6.0]
  def change
    create_table :qnas do |t|
      t.integer :user_id
      t.integer :tutor_id
      t.text :question
      t.string :subject
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
