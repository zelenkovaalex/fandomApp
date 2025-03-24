class CreateFandomsProfilesJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_table :fandoms_profiles, id: false do |t|
      t.references :fandom, foreign_key: true
      t.references :profile, foreign_key: true
    end

    add_index :fandoms_profiles, [:fandom_id, :profile_id], unique: true
  end
end
