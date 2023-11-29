class AddMinBidOffer < ActiveRecord::Migration[6.0]
  def change
    add_column :homeworks, :min_bid, :integer
  end
end
