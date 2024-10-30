class AddPublicToTrail < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :public, :boolean, default: false
  end
end
