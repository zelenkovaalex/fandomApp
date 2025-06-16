class CreateFandomsProfiles < ActiveRecord::Migration[7.2]
  def change
    unless table_exists?(:fandoms_profiles)
      create_table :fandoms_profiles do |t|
        t.integer :fandom_id, null: false
        t.integer :profile_id, null: false
        t.timestamps
      end
    end
  end
end