class AddUserIdToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :user_id, :integer
  end
end
