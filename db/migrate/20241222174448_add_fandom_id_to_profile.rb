class AddFandomIdToProfile < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :fandom_id, :integer
  end
end
