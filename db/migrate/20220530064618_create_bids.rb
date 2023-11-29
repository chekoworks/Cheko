class CreateBids < ActiveRecord::Migration[6.0]
  def change
    create_table :bids do |t|
      t.integer :homework_id
      t.integer :tutor_id
      t.integer :ammount
      t.timestamps
    end
  end
end
