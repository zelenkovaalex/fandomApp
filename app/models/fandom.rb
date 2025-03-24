class Fandom < ApplicationRecord
    has_many :trails
    has_and_belongs_to_many :profiles
end
