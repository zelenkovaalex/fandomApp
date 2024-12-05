class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.string :likeable_type
      t.integer :likeable_id
      t.integer :user_id

      t.timestamps
    end
  end
end
