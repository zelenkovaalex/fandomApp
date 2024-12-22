class CreateTagSelecteds < ActiveRecord::Migration[7.2]
  def change
    create_table :tag_selecteds do |t|
      t.references :trail, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
