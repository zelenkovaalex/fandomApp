class AddLinkToProfile < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :link, :string
  end
end
