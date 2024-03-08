class CreateHumanizeAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :humanize_answers do |t|
      t.integer :position
      t.text :answer
      t.text :humanized_output
      t.string :undetectable_ai_id
      t.integer :conversation_id

      t.timestamps
    end
  end
end
