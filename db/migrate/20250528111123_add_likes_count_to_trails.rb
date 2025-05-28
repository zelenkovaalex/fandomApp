class AddLikesCountToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :likes_count, :integer, default: 0
  end
end
