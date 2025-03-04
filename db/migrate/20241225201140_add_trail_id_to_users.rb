class AddTrailIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :trail, foreign_key: true
  end
end