class AddDistanceToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :distance, :integer
  end
end
