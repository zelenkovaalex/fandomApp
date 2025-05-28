class AddCommentsCountToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :comments_count, :integer, default: 0
  end
end
