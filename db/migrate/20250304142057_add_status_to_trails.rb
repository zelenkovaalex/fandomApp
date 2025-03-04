class AddStatusToTrails < ActiveRecord::Migration[7.1]
  def change
    add_column :trails, :status, :string, default: 'inactive'
  end
end