class CreateTrailPoints < ActiveRecord::Migration[7.2]
  def change
    create_table :trail_points do |t|
      t.references :trail, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :image
      t.decimal :latitude
      t.decimal :longitude
      t.string :map_link

      t.timestamps
    end
  end
end
