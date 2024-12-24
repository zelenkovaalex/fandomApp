class CreateFandoms < ActiveRecord::Migration[7.2]
  def change
    create_table :fandoms do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description

      t.timestamps
    end
  end
end
