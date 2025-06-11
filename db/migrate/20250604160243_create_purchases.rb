class CreatePurchases < ActiveRecord::Migration[7.2]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trail, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.string :status, default: "pending"
      t.datetime :purchased_at

      t.timestamps
    end
  end
end