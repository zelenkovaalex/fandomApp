class AddDurationToTrails < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:trails, :duration)
      add_column :trails, :duration, :integer
    end
  end
end
