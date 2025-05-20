class CreateTrails < ActiveRecord::Migration[7.2]
  def change
    create_table :trails do |t|
      t.string :title
      t.json :fandom
      t.string :trail_time
      t.string :trail_level
      t.text :body
      t.string :fandom_id
      t.integer :duration
      t.string :duration_unit
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
