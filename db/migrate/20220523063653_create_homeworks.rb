class CreateHomeworks < ActiveRecord::Migration[6.0]
  def change
    create_table :homeworks do |t|
      t.integer :user_id
      t.integer :tutor_id
      t.timestamps
    end
  end
end
