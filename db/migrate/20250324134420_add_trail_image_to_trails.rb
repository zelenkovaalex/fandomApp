class AddTrailImageToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :trail_image, :string
  end
end
