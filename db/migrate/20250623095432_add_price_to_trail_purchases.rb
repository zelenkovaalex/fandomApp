class AddPriceToTrailPurchases < ActiveRecord::Migration[7.2]
  def change
    add_column :trail_purchases, :price, :integer
  end
end
