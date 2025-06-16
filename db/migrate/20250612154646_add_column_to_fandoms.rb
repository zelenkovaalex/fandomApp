class AddColumnToFandoms < ActiveRecord::Migration[7.2]
  def change
    add_column :fandoms, :category, :text
  end
end
