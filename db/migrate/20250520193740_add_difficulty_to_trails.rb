class AddDifficultyToTrails < ActiveRecord::Migration[7.2]
  def change
    add_column :trails, :difficulty, :string
  end
end
