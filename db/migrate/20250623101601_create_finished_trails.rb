class CreateFinishedTrails < ActiveRecord::Migration[7.2]
  def change
    create_table :finished_trails do |t|
      t.integer :user_id, null: false
      t.integer :trail_id, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end

    add_index :finished_trails, :user_id
    add_index :finished_trails, :trail_id
    add_index :finished_trails, [:user_id, :trail_id], unique: true
  end
end
