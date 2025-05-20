class AddRatingValueToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :rating_value, :integer
  end
end
