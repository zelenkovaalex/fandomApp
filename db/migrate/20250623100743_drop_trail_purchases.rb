class DropTrailPurchases < ActiveRecord::Migration[7.2]
  def up
    drop_table :trail_purchases
  end

  def down
    create_table :trail_purchases do |t|
      t.integer :user_id, null: false
      t.integer :trail_id, null: false
      t.datetime :purchased_at, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :price
    end
  end
end