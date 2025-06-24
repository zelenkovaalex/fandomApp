class Fandom < ApplicationRecord
    include PgSearch::Model
    has_many :trails, dependent: :destroy
    has_and_belongs_to_many :profiles

    has_many :fandoms_profiles
    has_many :profiles, through: :fandoms_profiles

    pg_search_scope :search_by_title_and_description,
    against: { name: 'A', description: 'B' },
    using: {
      tsearch: { prefix: true }
    }
end
