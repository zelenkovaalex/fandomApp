class Fandom < ApplicationRecord
    has_many :trails, dependent: :destroy
    has_and_belongs_to_many :profiles

    has_many :fandoms_profiles
    has_many :profiles, through: :fandoms_profiles
end
