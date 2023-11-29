class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.integer :homework_id
      t.integer :name
      t.timestamps
    end
  end
end
