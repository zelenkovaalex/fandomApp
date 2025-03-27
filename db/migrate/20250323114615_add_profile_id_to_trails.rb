class AddProfileIdToTrails < ActiveRecord::Migration[7.2]
  def change
    add_reference :trails, :profile, null: false, foreign_key: true  end
  end