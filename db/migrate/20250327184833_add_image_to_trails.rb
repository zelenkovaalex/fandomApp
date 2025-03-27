class AddImageToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :image, :string
  end
end
