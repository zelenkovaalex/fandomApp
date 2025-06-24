class CreateGalleries < ActiveRecord::Migration[7.2]
  def change
    create_table :galleries do |t|
      t.references :trail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
