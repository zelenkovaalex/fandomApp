class ChangeFandomIdToNamesInProfiles < ActiveRecord::Migration[7.2]
  def up
    remove_column :profiles, :fandom_id

    execute <<-SQL
      ALTER TABLE profiles ADD COLUMN fandom_names TEXT[];
    SQL
  end

  def down
    remove_column :profiles, :fandom_names
    add_column :profiles, :fandom_id, :integer
  end
end
