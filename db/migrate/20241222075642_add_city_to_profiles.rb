class AddCityToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :city, :string
  end
end
