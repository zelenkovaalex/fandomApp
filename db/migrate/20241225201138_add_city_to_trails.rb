class AddCityToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :city, :string
  end
end
