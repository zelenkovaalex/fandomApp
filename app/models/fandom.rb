class Fandom < ApplicationRecord
    has_many :trails, dependent: :destroy
    has_and_belongs_to_many :profiles
end
