class AddEmailProfessor < ActiveRecord::Migration[6.0]
  def change
    add_column :professors, :email, :string
  end
end
