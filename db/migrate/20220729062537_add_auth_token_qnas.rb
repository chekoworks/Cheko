class AddAuthTokenQnas < ActiveRecord::Migration[6.0]
  def change
    add_column :qnas, :auth, :string
  end
end
