class Tag < ApplicationRecord
    has_many :tag_selecteds
    has_many :trails, through: :tag_selecteds
end
