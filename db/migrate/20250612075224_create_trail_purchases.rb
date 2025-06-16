class CreateTrailPurchases < ActiveRecord::Migration[7.2]
  def change
    create_table :trail_purchases do |t|
      t.integer :user_id, null: false
      t.integer :trail_id, null: false
      t.datetime :purchased_at, null: false

      t.timestamps
    end

    add_index :trail_purchases, :user_id
    add_index :trail_purchases, :trail_id
    add_index :trail_purchases, [:user_id, :trail_id], unique: true
  end
end