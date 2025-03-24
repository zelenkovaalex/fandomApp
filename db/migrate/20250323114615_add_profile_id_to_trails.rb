class AddProfileIdToTrails < ActiveRecord::Migration[7.0]
  def change
    add_reference :trails, :profile, foreign_key: true
  end
end